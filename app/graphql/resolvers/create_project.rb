class Resolvers::CreateProject < GraphQL::Function
  # arguments passed as "args"
  argument :title, types.String
  argument :slug, types.String
  argument :status, types.String
  argument :description, types.String
  argument :caption, types.String
  argument :milestones, types.String
  argument :repo_url, types.String
  argument :category, types.String
  argument :feature_image, types.String
  argument :project_url, types.String
  argument :technical_information, types.String
  argument :tags, types.String

	description 'This function allows a user to create a portfolio project.'

  # return type from the mutation
  type Types::ProjectType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)

    project = Project.where(slug: args[:slug]).first

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
    if args[:category].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "category_field" } )
	    ctx.add_error(error)
    end
    if args[:feature_image].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "feature_image_field" } )
	    ctx.add_error(error)
    end
    if args[:technical_information].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "technical_information_field" } )
	    ctx.add_error(error)
    end

    if project.present?
      error = GraphQL::ExecutionError.new("This slug has been used.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    project = Project.create!(
      title: args[:title],
      slug: args[:slug],
      status: args[:status],
      description: args[:description],
      caption: args[:caption],
      milestones: args[:milestones],
      repo_url: args[:repo_url],
      category: args[:category],
      feature_image: args[:feature_image],
      project_url: args[:project_url],
      technical_information: args[:technical_information]
    )

    tags = args[:tags].split(',')

    for t in tags
      Tag.create!(
        title: t[:title],
        project_id: project.id,
        status: "Project"
      )
    end
    return project
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
