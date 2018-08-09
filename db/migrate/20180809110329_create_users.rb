class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.string :password_digest
      t.string :profile_picture

      t.timestamps
    end
  end
end
