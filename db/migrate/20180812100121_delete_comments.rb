class DeleteComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :upvote_count
    add_column :comments, :status, :string
    add_column :comments, :slug, :string
  end
end
