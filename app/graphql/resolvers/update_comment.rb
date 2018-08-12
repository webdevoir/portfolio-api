class Resolvers::UpdateComment < GraphQL::Function
  # arguments passed as "args"
  argument :comment_id, !types.Int
  argument :slug, !types.String
  argument :status, !types.String

	description 'This function allows a user to update a comment for a portfolio project.'

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

    comment = Comment.find_by(id: args[:comment_id], slug: args[:slug], status: args[:status])

    if comment.blank?
      raise GraphQL::ExecutionError.new("This comment does not exist.", options: { field: "notification" } )
    end

    if args[:comment_id].blank?
      error = GraphQL::ExecutionError.new("Please include the comment ID.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("Please include the project ID.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    comment.body = args[:body]
    comment.save!
    return comment
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
