class Resolvers::CreateProject < GraphQL::Function
  # arguments passed as "args"
  argument :title, !types.String
  argument :slug, !types.String
  argument :status, !types.String
  argument :description, !types.String
  argument :caption, !types.String
  argument :milestones, !types.String
  argument :repo_url, !types.String
  argument :category, !types.String
  argument :feature_image, !types.String
  argument :project_url, !types.String
  argument :technical_information, !types.String

	description 'This function allows a user to update a portfolio project.'

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

    project = Project.find_by(slug: args[:slug]).first

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if args[:slug].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end

    if project.blank?
      error = GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notfield" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    project.destroy!
    return project
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
