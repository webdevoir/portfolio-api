class RemoveProjectIdFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :project_id
  end
end
