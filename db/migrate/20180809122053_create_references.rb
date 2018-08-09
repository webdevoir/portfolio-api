class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.string :title
      t.string :name
      t.string :avatar
      t.string :body
      t.string :company
    end
  end
end
