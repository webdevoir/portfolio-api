class Resolvers::CreateProjectImage < GraphQL::Function
  # arguments passed as "args"
  argument :slug, !types.String
  argument :image_url, !types.String

	description 'This function allows an admin to add a project screenshot for a portfolio project.'

  # return type from the mutation
  type Types::ProjectImageType

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

    project = Project.find_by(slug: args[:slug])

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if project.blank?
      raise GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
    end

    if args[:project_id].blank?
      error = GraphQL::ExecutionError.new("Please include a Project ID.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if args[:image_url].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "image_url_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    ProjectImage.create!(
      project_id: args[:project_id],
      image_url: args[:image_url],
      project: project
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
