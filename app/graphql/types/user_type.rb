Types::UserType = GraphQL::ObjectType.define do
  name 'User'

  field :id, !types.ID
  field :name, !types.String, description: 'Name of the user'
  field :email, !types.String, description: 'User email'
  field :admin, !types.Boolean, description: 'Admin status of the user'
  field :password_digest, !types.String, description: 'User password digest'
  field :profile_picture, !types.String, description: 'Profile picture of the user'
  field :password_reset, !types.String, description: 'Password reset token for users'
end
