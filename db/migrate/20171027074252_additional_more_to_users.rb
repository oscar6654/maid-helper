class AdditionalMoreToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :is_verified
    add_column :users, :is_verified, :boolean, default: false
    add_column :users, :phone_number, :string
  end
end
