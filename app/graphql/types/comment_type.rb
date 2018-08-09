Types::CommentType = GraphQL::ObjectType.define do
  name 'Comment'

  field :id, !types.ID
  field :body, !types.String, description: 'Name of the user'
  field :project_id, !types.Int, description: 'ID of the project'
  field :upvote_count, !types.Int, description: 'Amount of upvotes comment has received'
  field :created_at, !types.String, description: 'Created at date'
  field :user_id, !types.Int, description: 'ID of the associated user'
  field :project, -> { Types::ProjectType }, description: 'Link to project object'
  field :upvotes, -> { Types::UpvotesType }, description: 'Link to upvotes object'
  field :user, -> { Types::UserType }, description: 'Link to user object'
end
