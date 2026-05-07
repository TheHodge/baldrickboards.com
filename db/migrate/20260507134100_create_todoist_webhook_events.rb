class CreateTodoistWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :todoist_webhook_events do |t|
      t.string :event_key, null: false
      t.string :event_name
      t.jsonb :payload, null: false, default: {}
      t.datetime :processed_at, null: false

      t.timestamps
    end

    add_index :todoist_webhook_events, :event_key, unique: true
  end
end
