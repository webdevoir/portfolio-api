class ProjectImage < ApplicationRecord
  belongs_to :project, validate: true
end
