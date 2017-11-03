class AddUniqPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :phone_number
    add_column :users, :phone_number, :string
    add_index :users, :phone_number, unique: true
  end
end
