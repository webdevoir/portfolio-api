Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createProject, function: Resolvers::CreateProject.new
  field :updateProject, function: Resolvers::UpdateProject.new
  field :deleteProject, function: Resolvers::DeleteProject.new
end
