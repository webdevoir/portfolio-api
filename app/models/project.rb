class Project < ApplicationRecord
  has_many :comments
  has_many :project_images
  has_many :tags
end
