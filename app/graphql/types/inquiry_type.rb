Types::InquiryType = GraphQL::ObjectType.define do
  name 'Inquiry'

  field :id, !types.ID
  field :name, !types.String, description: 'Name of the user who submitted the inquiry'
  field :email, !types.String, description: 'Name of the email who submitted the inquiry'
  field :message, !types.String, description: 'The message of the inquiry'
  field :category, !types.String, description: 'The category of the inquiry'
end
