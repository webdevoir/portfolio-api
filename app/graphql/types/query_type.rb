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
end
