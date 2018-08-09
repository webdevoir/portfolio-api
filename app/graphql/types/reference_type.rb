Types::ReferenceType = GraphQL::ObjectType.define do
  name 'Reference'

  field :id, !types.ID
  field :title, !types.String, description: 'The persons title'
  field :name, !types.String, description: 'The persons name'
  field :avatar, !types.String, description: 'The persons avatar'
  field :body, !types.String, description: 'The persons body'
  field :company, !types.String, description: 'The company the person works at'
end
