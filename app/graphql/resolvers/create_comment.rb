class Resolvers::CreateComment < GraphQL::Function
  # arguments passed as "args"
  argument :project_id, !types.String
  argument :body, !types.String

	description 'This function allows a user to submit a comment for a portfolio project.'

  # return type from the mutation
  type Types::Projectype

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

    if project.blank?
      raise GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
    end

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "notification" } )
	    ctx.add_error(error)
    end
    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Comment.create!(
      project_id: args[:project_id],
      body: args[:body],
      user_id: ctx[:current_user][:id],
      user: ctx[:current_user],
      upvote_count: 0,
      project: project
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
