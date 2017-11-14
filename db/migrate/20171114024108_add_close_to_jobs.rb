class AddCloseToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :job_closed, :boolean, default: false
  end
end
