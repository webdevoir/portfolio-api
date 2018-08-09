Types::UpvoteType = GraphQL::ObjectType.define do
  name 'Upvote'

  field :id, !types.ID
  field :project_id, !types.Int, description: 'ID of the project'
  field :comment_id, !types.Int, description: 'ID of the comment'
  field :user_id, !types.Int, description: 'ID of the associated user'
  field :project, -> { Types::ProjectType }, description: 'Link to project object'
  field :comment, -> { Types::CommentType }, description: 'Link to comment object'
  field :user, -> { Types::UserType }, description: 'Link to user object'
end
