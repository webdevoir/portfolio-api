class Resolvers::DeleteReference < GraphQL::Function
  # arguments passed as "args"
  argument :reference_id, !types.Int

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
    
    reference.destroy!
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
