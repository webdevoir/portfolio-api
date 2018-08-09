Types::ProjectType = GraphQL::ObjectType.define do
  name 'Project'

  field :id, !types.ID
  field :title, !types.String, description: 'Project title'
  field :slug, !types.String, description: 'Project slug'
  field :status, !types.String, description: 'Status of the project'
  field :description, !types.String, description: 'Description of the project'
  field :caption, !types.String, description: 'Caption of the project'
  field :milestones, !types.String, description: 'Milestones accomplished in the project'
  field :repo_url, !types.String, description: 'Repo URL of the project'
  field :category, !types.String, description: 'Category of the project'
  field :created_at, types.String, description: 'Updated at timestamp'
  field :updated_at, !types.String, description: 'Created at timestamp'
  field :feature_image, !types.String, description: 'Feature image of the project'
  field :project_url, !types.String, description: 'URL of the project'
  field :technical_information, !types.String, description: 'Project technical information'
end
