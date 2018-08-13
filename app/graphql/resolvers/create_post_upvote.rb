class Resolvers::CreatePostUpvote < GraphQL::Function
  # arguments passed as "args"
  argument :slug, !types.String

	description 'This function allows a user to upvote a comment'

  # return type from the mutation
  type Types::UpvoteType

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

    if args[:slug].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    project = Project.find_by(slug: args[:slug])

    comment = Comment.first

    upvote = Upvote.find_by(project_id: args[:project_id], comment_id: 1)

    if upvote.present?
      upvote.destroy!
      return user
    end

    post = Post.find_by(slug: args[:slug])
    post_id = post.id

    if post.blank?
      raise GraphQL::ExecutionError.new("This blog post does not exist.", options: { field: "notification" } )
    end


    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Upvote.create!(
      project_id: post_id,
      comment_id: 1,
      user_id: ctx[:current_user][:id],
      user: ctx[:current_user],
      comment: comment
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
