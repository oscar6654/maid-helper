class AddDataToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_verified, :boolean
    add_column :users, :proof, :string
    add_column :users, :cooking_skills, :string
    add_column :users, :cleaning_skills, :string
    add_column :users, :dialect, :string
    add_column :users, :current_location, :string
    add_column :users, :age, :string
    add_column :users, :gender, :string
    add_column :users, :language, :string
  end
end
