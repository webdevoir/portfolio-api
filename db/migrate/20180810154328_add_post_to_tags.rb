class AddPostToTags < ActiveRecord::Migration[5.1]
  def change
    add_reference :tags, :project, foreign_key: true
  end
end
