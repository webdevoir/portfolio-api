Types::FeedbackType = GraphQL::ObjectType.define do
  name 'Feedback'

  field :id, !types.ID
  field :title, !types.String, description: 'Feedback entry title'
  field :body, !types.String, description: 'Feedback body (supports markdown)'
end
