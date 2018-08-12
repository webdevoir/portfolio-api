class AddConfirmedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :confirmed, :boolean
    add_column :users, :confirm_token, :string
  end
end
