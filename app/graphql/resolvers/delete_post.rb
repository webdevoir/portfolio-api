class Resolvers::DeletePost < GraphQL::Function
  # arguments passed as "args"
  argument :post_id, !types.Int

	description 'This function allows an admin to delete a blog post.'

  # return type from the mutation
  type Types::PostType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
		if ctx[:current_user].blank?
      raise GraphQL::ExecutionError.new("Authentication required.")
    else
      user = User.find_by(id: ctx[:current_user][:id])
    end

    post = Post.find_by(id: args[:post_id])

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if args[:post_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end

    if post.blank?
      error = GraphQL::ExecutionError.new("This blog post does not exist.", options: { field: "notfield" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    post.destroy!
    return post
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
