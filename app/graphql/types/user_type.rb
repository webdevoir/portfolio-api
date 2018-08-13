Types::UserType = GraphQL::ObjectType.define do
  name 'User'

  field :id, !types.ID
  field :name, !types.String, description: 'Name of the user'
  field :email, !types.String, description: 'Email of the user'
  field :bio, !types.String, description: 'Bio of the user'
  field :confirmed, !types.Boolean, description: 'Confirmed status of the user'
  field :admin, !types.Boolean, description: 'Admin status of the user'
  field :profile_picture, !types.String, description: 'Profile picture of the user'
  field :password_reset, !types.String, description: 'Password reset token for users'
end
