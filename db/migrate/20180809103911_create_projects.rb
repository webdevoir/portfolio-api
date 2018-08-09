class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :slug
      t.string :status
      t.string :description
      t.string :caption
      t.string :milestones
      t.string :repo_url
      t.string :category
      t.string :created_at
      t.string :updated_at
      t.string :feature_image
      t.string :project_url
      t.string :technical_information

      t.timestamps
    end
  end
end
