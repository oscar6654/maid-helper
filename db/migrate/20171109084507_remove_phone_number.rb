class RemovePhoneNumber < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :phone_number
    add_column :users, :proof_verified, :boolean, default: false
  end
end
