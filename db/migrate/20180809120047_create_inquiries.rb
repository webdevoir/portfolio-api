class CreateInquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiries do |t|
      t.string :name
      t.string :email
      t.string :message
      t.string :category

      t.timestamps
    end
  end
end
