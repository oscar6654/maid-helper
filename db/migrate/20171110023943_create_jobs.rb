class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :work_location, null: false
      t.text :job_description, null: false
      t.belongs_to :user, null: false
      t.timestamps null: false
    end
  end
end
