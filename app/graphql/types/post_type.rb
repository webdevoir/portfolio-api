Types::PostType = GraphQL::ObjectType.define do
  name 'Post'

  field :id, !types.ID
  field :title, !types.String, description: 'Blog post title'
  field :slug, !types.String, description: 'Blog post slug'
  field :status, !types.String, description: 'Status of the blog post'
  field :body, !types.String, description: 'Body of the blog post'
  field :description, !types.String, description: 'Description of the blog post'
  field :category, !types.String, description: 'Category of the blog post'
  field :feature_image, !types.String, description: 'Feature image of the blog post'
  field :comments, -> { Types::CommentType }, description: 'Link to comment object'
  field :user, -> { Types::UserType }, description: 'Link to user object'
  field :tags, -> { Types::TagType }, description: 'Link to tag object'
end
