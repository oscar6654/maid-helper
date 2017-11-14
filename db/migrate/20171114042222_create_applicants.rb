class CreateApplicants < ActiveRecord::Migration[5.1]
  def change
    create_table :applicants do |t|
      t.belongs_to :user, null: false
      t.belongs_to :job, null: false
      t.text :comments, null: false
      t.timestamps
    end
  end
end
