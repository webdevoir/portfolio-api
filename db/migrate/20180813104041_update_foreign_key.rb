class UpdateForeignKey < ActiveRecord::Migration[5.1]
  def change
    # remove the old foreign_key
    remove_foreign_key :posts, :users
    remove_foreign_key :tags, :projects

    # add the new foreign_key
    add_foreign_key :posts, :users, on_delete: :cascade
  end
end
