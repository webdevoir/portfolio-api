class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.string :body
      t.string :status
      t.string :feature_image
      t.string :created_at
      t.string :category
      t.references :tags, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
