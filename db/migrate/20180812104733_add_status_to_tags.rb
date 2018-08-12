class AddStatusToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :status, :string
  end
end
