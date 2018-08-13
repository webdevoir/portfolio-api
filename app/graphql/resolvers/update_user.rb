require 'sendgrid-ruby'
include SendGrid

class Resolvers::UpdateUser < GraphQL::Function
  # arguments passed as "args"
	argument :name, !types.String
  argument :email, !types.String
	argument :profile_picture, !types.String
	argument :bio, !types.String

	description 'This function allows a user to update their account.'

  # return type from the mutation
  type Types::UserType

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

		if args[:name].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "name_field" } )
      ctx.add_error(error)
    end

		if args[:email].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "email_field" } )
      ctx.add_error(error)
    end

		if args[:profile_picture].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "profile_picture_field" } )
      ctx.add_error(error)
    end

		if args[:bio].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "bio_field" } )
      ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

		if args[:email] != user.email
			code = SecureRandom.urlsafe_base64.to_s

			user.confirmed = false
			user.confirm_token = code

	    mail = Mail.new
	    mail.from = Email.new(email: 'support@opencommit.co')
	    mail.subject = 'Verify Your Open Commit Account'
	    personalization = Personalization.new
	    personalization.add_to(Email.new(email: args[:email]))
	    personalization.add_substitution(Substitution.new(key: '-name-', value: args[:name]))
	    personalization.add_substitution(Substitution.new(key: '-code-', value: code))
	    mail.add_personalization(personalization)
	    mail.template_id = 'd-3b99e1c73fa242079a042b30fc43beea'

	    sg = SendGrid::API.new(api_key: "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")
	    begin
	        response = sg.client.mail._("send").post(request_body: mail.to_json)
	    rescue Exception => e
	        puts e.message
	    end
		end

		user.name = args[:name]
		user.email = args[:email]
		user.profile_picture = args[:profile_picture]
		user.bio = args[:bio]
    user.save!
		return user
  end
end
