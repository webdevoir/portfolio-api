class Comment < ApplicationRecord
  belongs_to :user, validate: true

  has_many :upvotes
end
