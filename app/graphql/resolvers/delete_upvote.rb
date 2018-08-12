class Resolvers::DeleteUpvote < GraphQL::Function
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

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    comment.upvote_count = comment.upvote_count - 1
    comment.save!
    return comment
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
