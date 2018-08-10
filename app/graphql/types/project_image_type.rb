Types::ProjectImageType = GraphQL::ObjectType.define do
  name 'ProjectImage'

  field :id, !types.ID
  field :project_id, !types.Int, description: 'ID of the project'
  field :image_url, !types.String, description: 'URL of the image'
  field :project, -> { Types::ProjectType }, description: 'Link to project object'
end
