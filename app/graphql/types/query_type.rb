Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :getProjects, !types[Types::ProjectType] do
    argument :category, types.String
    resolve -> (obj, args, ctx) {
      if args[:category].present?
        return Project.find_by(category: args[:category])
      else
        return Project.all
      end
    }
  end
  field :getProject, !types[Types::ProjectType] do
    argument :slug, types.String
    resolve -> (obj, args, ctx) {
      project = Project.find_by(slug: args[:slug])
      return Project.where(id: project.id)
    }
  end

  field :getAdminPosts, !types[Types::PostType] do
    resolve -> (obj, args, ctx) {
      if ctx[:current_user].blank?
        raise GraphQL::ExecutionError.new("You need to be signed in to access this resource.")
			else
        return Post.all
      end
    }
  end

  field :getPosts, !types[Types::PostType] do
    argument :category, types.String
    resolve -> (obj, args, ctx) {
      if args[:category].present?
        return Post.where(category: args[:category], status: "Published")
      else
        return Post.where(status: "Published")
      end
    }
  end
  field :getPostsByTag, !types[Types::PostType] do
    argument :tag, types.String
    resolve -> (obj, args, ctx) {
      if args[:category].present?
        return Post.where(id: Tag.select("post_id").where(title: args[:tag]), status: "Published")
      else
        return Post.where(status: "Published")
      end
    }
  end
  field :getPost, !types[Types::PostType] do
    argument :slug, types.String
    resolve -> (obj, args, ctx) {
      return Post.where(slug: args[:slug])
    }
  end
  field :getProjectImages, !types[Types::ProjectImageType] do
    argument :slug, types.String
    resolve -> (obj, args, ctx) {
      project = Project.find_by(slug: args[:slug])
      return ProjectImage.where(project_id: project.id)
    }
  end
  field :getUpvotes, !types[Types::UpvoteType] do
    argument :slug, !types.String
    argument :status, !types.String
    argument :comment_id, !types.Int
    resolve -> (obj, args, ctx) {
      if args[:status] == "Project"
        project = Project.find_by(slug: args[:slug])
      else
        project = Post.find_by(slug: args[:slug])
      end
      if project.present?
        return Upvote.where(comment_id: args[:comment_id], project_id: project.id)
      else
        return Upvote.all
      end
    }
  end
  field :getMainPostUpvotes, !types[Types::UpvoteType] do
    argument :slug, !types.String
    resolve -> (obj, args, ctx) {
      project = Post.find_by(slug: args[:slug])
      return Upvote.where(comment_id: 1, project_id: project.id)
    }
  end
  field :getReferences, !types[Types::ReferenceType] do
    resolve -> (obj, args, ctx) {
      return Reference.all
    }
  end
  field :getProjectTags, !types[Types::TagType] do
    argument :slug, types.String
    resolve -> (obj, args, ctx) {
      project = Project.find_by(slug: args[:slug])
      return Tag.where(project_id: project.id, status: "Project")
    }
  end
  field :getPostTags, !types[Types::TagType] do
    argument :slug, types.String
    resolve -> (obj, args, ctx) {
      post = Post.find_by(slug: args[:slug])
      return Tag.where(project_id: post.id)
    }
  end
  field :getUsers, !types[Types::UserType] do
    resolve -> (obj, args, ctx) {
      if ctx[:current_user].blank?
        raise GraphQL::ExecutionError.new("You need to be signed in to access this resource.")
			else
        return User.all
      end
    }
  end
  field :getUser, !types[Types::UserType] do
    argument :user_id, types.Int
    resolve -> (obj, args, ctx) {
      if ctx[:current_user].blank?
        raise GraphQL::ExecutionError.new("You need to be signed in to access this resource.")
			else
        return User.find_by(id: args[:user_id])
      end
    }
  end
  field :getCurrentUser, !types[Types::UserType] do
    resolve -> (obj, args, ctx) {
      if ctx[:current_user].blank?
        raise GraphQL::ExecutionError.new("You need to be signed in to access this resource.")
			else
        return User.where(id: ctx[:current_user][:id])
      end
    }
  end
  field :getComments, !types[Types::CommentType] do
    argument :slug, types.String
    argument :status, types.String
    resolve -> (obj, args, ctx) {
      return Comment.where(slug: args[:slug], status: args[:status])
    }
  end
  field :getInquiries, !types[Types::InquiryType] do
    resolve -> (obj, args, ctx) {
      return Inquiry.all
    }
  end
  field :projectCategories, types[types.String] do
    resolve -> (obj, args, ctx) do
      Project.category.map { |a| a[0].capitalize }
    end
  end
end
