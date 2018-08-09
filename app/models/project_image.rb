class Upvote < ApplicationRecord
  belongs_to :project, validate: true
end
