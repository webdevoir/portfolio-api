class Comment < ApplicationRecord
  belongs_to :user, validate: true
end
