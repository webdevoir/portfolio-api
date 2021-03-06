Types::CommentType = GraphQL::ObjectType.define do
  name 'Comment'

  field :id, !types.ID
  field :body, !types.String, description: 'Name of the user'
  field :slug, !types.String, description: 'Post slug'
  field :status, !types.String, description: 'Post type'
  field :created_at, !types.String, description: 'Created at date'
  field :user_id, !types.Int, description: 'ID of the associated user'
  field :upvotes, -> { Types::UpvoteType }, description: 'Link to upvotes object'
  field :user, -> { Types::UserType }, description: 'Link to user object'
end
