class CreateUpvotes < ActiveRecord::Migration[5.1]
  def change
    create_table :upvotes do |t|
      t.integer :project_id
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
