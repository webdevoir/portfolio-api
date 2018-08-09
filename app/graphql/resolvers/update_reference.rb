class Resolvers::UpdateReference < GraphQL::Function
  # arguments passed as "args"
  argument :reference_id, !types.Int
  argument :title, !types.String
  argument :name, !types.String
  argument :avatar, !types.String
  argument :body, !types.String
  argument :company, !types.String

	description 'This function allows an admin to create a reference.'

  # return type from the mutation
  type Types::ReferenceType

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

    reference = Reference.find_by(id: args[:reference_id])

    if reference.blank?
      raise GraphQL::ExecutionError.new("This reference does not exist.")
    end

    if user.admin != true
      raise GraphQL::ExecutionError.new("You do not have access to this resource.")
    end

    if args[:title].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "title_field" } )
	    ctx.add_error(error)
    end
    if args[:name].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "name_field" } )
	    ctx.add_error(error)
    end
    if args[:avatar].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "avatar_field" } )
	    ctx.add_error(error)
    end
    if args[:body].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "body_field" } )
	    ctx.add_error(error)
    end
    if args[:company].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "company_field" } )
	    ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    reference.title = args[:title]
    reference.name = args[:name]
    reference.avatar = args[:avatar]
    reference.body = args[:body]
    reference.company = args[:company]
    reference.save!
    return reference
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
