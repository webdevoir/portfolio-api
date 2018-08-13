class Resolvers::DeleteProject < GraphQL::Function
  # arguments passed as "args"
  argument :project_id, !types.Int

	description 'This function allows an admin to delete a portfolio project.'

  # return type from the mutation
  type Types::ProjectType

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

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "project_id_field" } )
	    ctx.add_error(error)
    end

    if project.blank?
      error = GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notfield" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    tags = Tag.find_by(project_id: args[:project_id], status: "Project")

    if tags.present?
      tags.destroy!
    end

    project.destroy!
    return project
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
