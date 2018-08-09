class Resolvers::ResetPassword < GraphQL::Function
  # arguments passed as "args"
  argument :token, !types.String
  argument :new_password, !types.String
  argument :new_password_confirmation, !types.String

	description 'This function allows a user to reset their account password.'

  # return type from the mutation
  type Types::UserType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
		user = User.find_by(password_reset: args[:token])

    strength = PasswordStrength.test(user.name, args[:new_password])

    if strength.status != :strong && strength.status != :good
      error = GraphQL::ExecutionError.new("Your password must include at least one number and uppercase letter.", options: { field: "new_password_field"} )
      ctx.add_error(error)
    end

		if args[:new_password] != args[:new_password_confirmation]
	    error = GraphQL::ExecutionError.new("Your passwords do not match.", options: { field: "new_password_confirmation_field" } )
	    ctx.add_error(error)
	  end

		user.password = args[:new_password]
    user.save!
		return user
  end
end
