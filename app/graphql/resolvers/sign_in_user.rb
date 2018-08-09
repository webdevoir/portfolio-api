class Resolvers::SignInUser < GraphQL::Function
  argument :email, !Types::AuthProviderEmailInput

  # defines inline return type for the mutation
  type do
    name 'SigninPayload'

    field :token, types.String
    field :user, Types::UserType
  end

  def call(_obj, args, ctx)
    input = args[:email]

    # basic validation
    return unless input

    user = User.find_by email: input[:email]

    # ensures we have the correct user
    if user.blank?
      raise GraphQL::ExecutionError.new("Your email or password is incorrect")
    end
    if user.authenticate(input[:password]) == false
      raise GraphQL::ExecutionError.new("Your email or password is incorrect")
    end

    token = AuthToken.token(user)

    OpenStruct.new({
      token: token,
      user: user
    })
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
