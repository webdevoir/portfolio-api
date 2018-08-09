class CreateProjectImage < ActiveRecord::Migration[5.1]
  def change
    create_table :project_images do |t|
      t.integer :project_id
      t.string :image_url
    end
  end
end
