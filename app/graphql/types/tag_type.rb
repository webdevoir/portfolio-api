Types::TagType = GraphQL::ObjectType.define do
  name 'Tag'

  field :id, !types.ID
  field :title, !types.String, description: 'Tag title'
end
