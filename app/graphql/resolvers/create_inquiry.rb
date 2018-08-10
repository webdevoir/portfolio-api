class Resolvers::CreateInquiry < GraphQL::Function
  # arguments passed as "args"
	argument :name, !types.String
  argument :email, !types.String
	argument :message, !types.String
	argument :category, !types.String

	description 'This function allows a visitor to submit an inquiry.'

  # return type from the mutation
  type Types::InquiryType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, ctx)
		if ctx[:current_user].blank?
      raise GraphQL::ExecutionError.new("Authentication required.")
    else
      user = User.find_by(id: ctx[:current_user][:id])
    end

		if args[:name].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "name_field" } )
      ctx.add_error(error)
    end

		if args[:email].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "email_field" } )
      ctx.add_error(error)
    end

		if args[:message].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "message_field" } )
      ctx.add_error(error)
    end

		if args[:category].blank?
      error = GraphQL::ExecutionError.new("This field is required.", options: { field: "category_field" } )
      ctx.add_error(error)
    end

		accepted_categories = ['Employment Opportunities', 'General Questions', 'Suggestion', 'Something Else']

    if error.present?
      raise GraphQL::ExecutionError.new(ctx.errors)
    end

	  mail = Mail.new
	  mail.from = Email.new(email: 'support@jamesgallagher.co')
	  mail.subject = 'Inquiry - James Gallagher'
	  personalization = Personalization.new
	  personalization.add_to(Email.new(email: args[:email]))
	  personalization.add_substitution(Substitution.new(key: '-name-', value: args[:name]))
	  mail.add_personalization(personalization)
	  mail.template_id = '13b8f94f-bcae-4ec6-b752-70d6cb59f932'

	  sg = SendGrid::API.new(api_key: "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")
	  begin
	      response = sg.client.mail._("send").post(request_body: mail.to_json)
	  rescue Exception => e
	      puts e.message
	  end

		Inquiry.create!(
	    name: args[:name],
	    email: args[:email],
	    message: args[:message],
	    category: args[:category]
	  )
  end
end
