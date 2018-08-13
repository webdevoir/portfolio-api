class Resolvers::CreateUser < GraphQL::Function
  AuthProviderInput = GraphQL::InputObjectType.define do
    name 'AuthProviderSignupData'

    argument :email, Types::AuthProviderEmailInput
  end

  argument :name, !types.String
  argument :authProvider, !AuthProviderInput
  argument :password_confirmation, !types.String

  type Types::UserType

  def call(obj, args, ctx)

    strength = PasswordStrength.test(args[:name], args[:authProvider][:email][:password])

    if strength.status != :strong && strength.status != :good
      error = GraphQL::ExecutionError.new("Your password must include at least one number and uppercase letter.", options: { field: "password_field"} )
      ctx.add_error(error)
    end

    current_user = User.where(email: args[:authProvider][:email][:email])

    if current_user.present?
      error = GraphQL::ExecutionError.new("This email has been taken.", options: { field: "email_field" } )
      ctx.add_error(error)
    end

    if args[:authProvider][:email][:password] != args[:password_confirmation]
      error = GraphQL::ExecutionError.new("Your passwords do not match.", options: { field: "password_confirmation_field" } )
      ctx.add_error(error)
    end

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

    require 'sendgrid-ruby'

    code = SecureRandom.urlsafe_base64.to_s
    mail = Mail.new
    mail.from = Email.new(email: 'support@jamesgallagher.io')
    mail.subject = 'Verify Your Account - JamesGallagher.io'
    personalization = Personalization.new
    personalization.add_to(Email.new(email: args[:authProvider][:email][:email]))
    personalization.add_substitution(Substitution.new(key: '-name-', value: args[:name]))
    personalization.add_substitution(Substitution.new(key: '-code-', value: code))
    mail.add_personalization(personalization)
    mail.template_id = '13b8f94f-bcae-4ec6-b752-70d6cb59f932'

    sg = SendGrid::API.new(api_key: "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")
    begin
        response = sg.client.mail._("send").post(request_body: mail.to_json)
    rescue Exception => e
        puts e.message
    end

    User.create!(
      name: args[:name],
      email: args[:authProvider][:email][:email],
      password: args[:authProvider][:email][:password],
      admin: false,
      profile_picture: "http://bit.ly/2dqCGdd",
      confirmed: false,
      confirm_token: code,
      bio: ""
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
