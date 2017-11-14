class AddIndexToJob < ActiveRecord::Migration[5.1]
  def change
    add_index :jobs, :title
    add_index :jobs, :job_description
    add_index :jobs, :work_location
  end
end
