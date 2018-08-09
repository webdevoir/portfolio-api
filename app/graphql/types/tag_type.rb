Types::TagType = GraphQL::ObjectType.define do
  name 'Tag'

  field :id, !types.ID
  field :title, !types.String, description: 'Tag title'
  field :post_id, !types.Int, description: 'ID of the associated post'
  field :project, -> { Types::ProjectType }, description: 'Link to project object'
end
