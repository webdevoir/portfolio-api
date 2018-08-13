class Resolvers::CreateUpvote < GraphQL::Function
  # arguments passed as "args"
  argument :comment_id, !types.Int
  argument :slug, !types.String
  argument :status, !types.String

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

    if args[:comment_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    comment = Comment.find_by(id: args[:comment_id])

    upvote = Upvote.find_by(comment_id: args[:comment_id])

    if upvote.present?
      upvote.destroy!
      return user
    end

    if args[:status] == "Project"
      project = Project.find_by(slug: args[:slug])
      post_id = project.id

      if project.blank?
        raise GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
      end
    elsif args[:status] == "Post"
      post = Post.find_by(slug: args[:slug])
      post_id = post.id

      if post.blank?
        raise GraphQL::ExecutionError.new("This blog post does not exist.", options: { field: "notification" } )
      end
    end

    if comment.blank?
      raise GraphQL::ExecutionError.new("This comment does not exist.", options: { field: "notification" } )
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Upvote.create!(
      project_id: post_id,
      comment_id: args[:comment_id],
      user_id: ctx[:current_user][:id],
      user: ctx[:current_user],
      comment: comment
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
