Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createProject, function: Resolvers::CreateProject.new
  field :updateProject, function: Resolvers::UpdateProject.new
  field :deleteProject, function: Resolvers::DeleteProject.new

  field :createUser, function: Resolvers::CreateUser.new
  field :signInUser, function: Resolvers::SignInUser.new

  field :createComment, function: Resolvers::CreateComment.new
  field :updateComment, function: Resolvers::UpdateComment.new
  field :deleteComment, function: Resolvers::DeleteComment.new

  field :forgotPassword, function: Resolvers::ForgotPassword.new
  field :resetPassword, function: Resolvers::ResetPassword.new
end
