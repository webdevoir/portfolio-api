class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :upvote_count
      t.string :created_at
      t.integer :project_id

      t.timestamps
    end
  end
end
