class Upvote < ApplicationRecord
  belongs_to :user, validate: true
  belongs_to :comment, validate: true
end
