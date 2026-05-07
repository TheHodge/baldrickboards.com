class AddTodoistSyncFieldsToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :todoist_task_id, :string
    add_column :cases, :todoist_project_id, :string
    add_column :cases, :todoist_synced_at, :datetime
    add_column :cases, :todoist_sync_status, :string, default: "pending", null: false
    add_column :cases, :todoist_sync_error, :text
    add_column :cases, :todoist_last_event_at, :datetime

    add_index :cases, :todoist_task_id, unique: true
    add_index :cases, :todoist_sync_status
  end
end
