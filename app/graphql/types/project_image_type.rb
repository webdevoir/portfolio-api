Types::ProjectImageType = GraphQL::ObjectType.define do
  name 'ProjectImage'

  field :id, !types.ID
  field :image_url, !types.Int, description: 'ID of the project'
  field :project, -> { Types::ProjectType }, description: 'Link to project object'
end
