class AddReferencesToProjects < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :comments, foreign_key: true
    add_reference :projects, :project_images, foreign_key: true
    add_reference :projects, :tags, foreign_key: true
  end
end
