class Resolvers::UpdatePost < GraphQL::Function
  # arguments passed as "args"
  argument :title, types.String
  argument :slug, types.String
  argument :status, types.String
  argument :body, types.String
  argument :description, types.String
  argument :category, types.String
  argument :feature_image, types.String
  argument :tags, types.String

	description 'This function allows an admin user to update a blog post.'

  # return type from the mutation
  type Types::PostType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)

    post = Post.where(slug: args[:slug]).first

    if args[:title].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "title_field" } )
	    ctx.add_error(error)
    end
    if args[:status].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "status_field" } )
	    ctx.add_error(error)
    end
    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end
    if args[:description].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "description_field" } )
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

    accepted_status = ['Published', 'Draft']

    if accepted_status.exclude?(args[:status])
      error = GraphQL::ExecutionError.new("This status is invalid.", options: { field: "status_field" } )
	    ctx.add_error(error)
    end

    if post.blank?
      error = GraphQL::ExecutionError.new("This post does not exist.", options: { field: "slug_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    post.title = args[:title]
    post.status = args[:status]
    post.body = args[:body]
    post.description = args[:description]
    post.category = args[:category]
    post.feature_image = args[:feature_image]
    post.save!

    current_tags = Tag.where(post_id: post.id, status: "Blog")
    current_tags.destroy!

    tags = args[:tags].split(',')

    for t in tags
      Tag.create!(
        title: t[:title],
        post_id: post.id
      )
    end
    return post
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
