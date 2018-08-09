require 'sendgrid-ruby'
include SendGrid

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

    User.create!(
      name: args[:name],
      email: args[:authProvider][:email][:email],
      password: args[:authProvider][:email][:password],
      admin: false,
      profile_picture: "https://avatars2.githubusercontent.com/u/41574666?s=400&v=4"
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
