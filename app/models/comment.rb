class Comment < ApplicationRecord
  belongs_to :user, validate: true
  belongs_to :project, validate: true

  has_many :upvotes
end
