class Resolvers::CreateComment < GraphQL::Function
  # arguments passed as "args"
  argument :slug, !types.String
  argument :status, !types.String
  argument :body, !types.String

	description 'This function allows a user to submit a comment for a portfolio project.'

  # return type from the mutation
  type Types::CommentType

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

    if args[:status] == "Project"
      project = Project.find_by(slug: args[:slug])

      if project.blank?
        raise GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
      end
    elsif args[:status] == "Post"
      post = Post.find_by(slug: args[:slug])

      if post.blank?
        raise GraphQL::ExecutionError.new("This blog post does not exist.", options: { field: "notification" } )
      end
    end

    if args[:slug].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end

    if args[:status].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "status_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Comment.create!(
      slug: args[:slug],
      status: args[:status],
      body: args[:body],
      user: ctx[:current_user]
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
