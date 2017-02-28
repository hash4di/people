class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, index: true
      t.string :notification_type
      t.string :notification_status
      t.integer :receiver_id, index: true

      t.timestamps null: false
    end
  end
end
