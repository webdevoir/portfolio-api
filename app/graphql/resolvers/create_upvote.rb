class Resolvers::CreateUpvote < GraphQL::Function
  # arguments passed as "args"
  argument :comment_id, !types.Int
  argument :project_id, !types.Int

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

    project = Project.find_by(id: args[:project_id])
    comment = Comment.find_by(id: args[:comment_id], project_id: args[:project_id])

    if project.blank?
      raise GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
    end

    if comment.blank?
      raise GraphQL::ExecutionError.new("This comment does not exist.", options: { field: "notification" } )
    end

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Upvote.create!(
      project_id: args[:project_id],
      comment_id: args[:comment_id],
      user_id: ctx[:current_user][:id],
      user: ctx[:current_user],
      project: project,
      comment: comment
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end