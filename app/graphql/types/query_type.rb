Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # TODO: remove me
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
      if args[:slug].present?
        return Project.find_by(slug: args[:slug])
      else
        return Project.all.first
      end
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
end
