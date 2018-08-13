Types::TagType = GraphQL::ObjectType.define do
  name 'Tag'

  field :id, !types.ID
  field :title, !types.String, description: 'Tag title'
  field :project_id, !types.Int, description: 'ID of the associated post'
  field :status, !types.String, description: 'Tag status'
end
