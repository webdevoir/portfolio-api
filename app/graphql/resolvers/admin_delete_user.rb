require 'sendgrid-ruby'
include SendGrid

class Resolvers::AdminDeleteUser < GraphQL::Function
  # arguments passed as "args"
	argument :user_id, !types.Int

	description 'This function allows an admin to delete a user account.'

  # return type from the mutation
  type Types::UserType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
		user = User.find_by(id: ctx[:current_user][:id])
		target = User.find_by(user_id: args[:user_id])
		if ctx[:current_user].blank?
      raise GraphQL::ExecutionError.new("Authentication required.")
    end
		if target.blank?
			raise GraphQL::ExecutionError.new("This user does not exist.")
    end
		if user.admin != true
			raise GraphQL::ExecutionError.new("You do not have permission to access this resource.")
    end

    target.destroy!
		return user
  end
end
