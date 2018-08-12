Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createProject, function: Resolvers::CreateProject.new
  field :updateProject, function: Resolvers::UpdateProject.new
  field :deleteProject, function: Resolvers::DeleteProject.new

  field :createPost, function: Resolvers::CreatePost.new
  field :updatePost, function: Resolvers::UpdatePost.new
  field :deletePost, function: Resolvers::DeletePost.new

  field :createInquiry, function: Resolvers::CreateInquiry.new

  field :createUser, function: Resolvers::CreateUser.new
  field :signInUser, function: Resolvers::SignInUser.new
  field :updateUser, function: Resolvers::UpdateUser.new

  field :createComment, function: Resolvers::CreateComment.new
  field :updateComment, function: Resolvers::UpdateComment.new
  field :deleteComment, function: Resolvers::DeleteComment.new

  field :createReference, function: Resolvers::CreateReference.new
  field :updateReference, function: Resolvers::UpdateReference.new
  field :deleteReference, function: Resolvers::DeleteReference.new

  field :forgotPassword, function: Resolvers::ForgotPassword.new
  field :resetPassword, function: Resolvers::ResetPassword.new
end
