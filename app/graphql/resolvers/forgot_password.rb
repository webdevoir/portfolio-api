require 'sendgrid-ruby'
include SendGrid

class Resolvers::ForgotPassword < GraphQL::Function
  # arguments passed as "args"
  argument :email, !types.String

	description 'This function allows a user to request a password reset.'

  # return type from the mutation
  type Types::UserType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
		user = User.find_by(email: args[:email])

    if user.present?
      code = SecureRandom.urlsafe_base64.to_s
      mail = Mail.new
      mail.from = Email.new(email: 'support@opencommit.co')
      mail.subject = 'Open Commit - Reset Your Password'
      personalization = Personalization.new
      personalization.add_to(Email.new(email: args[:authProvider][:email][:email]))
      personalization.add_substitution(Substitution.new(key: '-name-', value: args[:name]))
      personalization.add_substitution(Substitution.new(key: '-code-', value: code))
      mail.add_personalization(personalization)
      mail.template_id = '13b8f94f-bcae-4ec6-b752-70d6cb59f932'

  		user.password_reset = code
      user.save!
    end
		return user
  end
end
