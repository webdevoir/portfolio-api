class Resolvers::UpdateProject < GraphQL::Function
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

    project = Project.find_by(slug: args[:slug]).first

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if project.blank?
      error = GraphQL::ExecutionError.new("This project does not exist.", options: { field: "notification" } )
	    ctx.add_error(error)
    end

    if args[:title].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "title_field" } )
	    ctx.add_error(error)
    end
    if args[:slug].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end
    if args[:status].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "status_field" } )
	    ctx.add_error(error)
    end
    if args[:description].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "description_field" } )
	    ctx.add_error(error)
    end
    if args[:caption].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "caption_field" } )
	    ctx.add_error(error)
    end
    if args[:milestones].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "milestones_field" } )
	    ctx.add_error(error)
    end
    if args[:repo_url].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "repo_url_field" } )
	    ctx.add_error(error)
    end
    if args[:category].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "category_field" } )
	    ctx.add_error(error)
    end
    if args[:feature_image].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "feature_image_field" } )
	    ctx.add_error(error)
    end
    if args[:project_url].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "project_url_field" } )
	    ctx.add_error(error)
    end
    if args[:technical_information].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "technical_information_field" } )
	    ctx.add_error(error)
    end

    if project.blank?
      error = GraphQL::ExecutionError.new("This project does not exist.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    project.title = args[:title]
    project.slug = args[:slug]
    project.status = args[:status]
    project.description = args[:description]
    project.caption = args[:caption]
    project.milestones = args[:milestones]
    project.repo_url = args[:repo_url]
    project.category = args[:category]
    project.feature_image = args[:feature_image]
    project.project_url = args[:project_url]
    project.technical_information = args[:technical_information]
    project.save!
    return project
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
