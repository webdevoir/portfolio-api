class AddPasswordResetToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_reset, :string
  end
end
