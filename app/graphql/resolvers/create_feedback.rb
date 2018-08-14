class Resolvers::CreateFeedback < GraphQL::Function
  # arguments passed as "args"
  argument :title, !types.String
  argument :body, !types.String

	description 'This function allows a visitor to submit feedback.'

  # return type from the mutation
  type Types::FeedbackType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
    if args[:title].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "title_field" } )
	    ctx.add_error(error)
    end

    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    Feedback.create!(
      title: args[:title],
      body: args[:body]
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
