class AddEmailNotif < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :email_notifications, :boolean, default: false
    add_column :jobs, :text_notifications, :boolean, default: false
  end
end
