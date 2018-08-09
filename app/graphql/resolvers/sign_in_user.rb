# app/graphql/mutations/sign_in_user.rb
class Mutations::SignInUser < GraphQL::Function
  # define the arguments this field will receive
  argument :email, !Types::AuthProviderEmailInput

  # define what this field will return
  type Types::AuthenticateType

  # resolve the field's response
  def call(obj, args, ctx)
    input = args[:email]
    return unless input

    user = User.find_by(email: input[:email])
    return unless user
    return unless user.authenticate(input[:password])

    OpenStruct.new({
      token: AuthToken.token(user),
      user: user
    })
  end
end
