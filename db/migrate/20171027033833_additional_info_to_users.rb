class AdditionalInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :additional_desc, :text
    add_column :users, :preffered_location, :string
    remove_column :users, :language
  end
end
