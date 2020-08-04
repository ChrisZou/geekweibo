class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.uuid :recipient_id
      t.uuid :actor_id
      t.datetime :read_at
      t.string :action
      t.uuid :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
