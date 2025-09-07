class CreateSearchLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_logs do |t|
      t.string :query, null: false
      t.string :result_url
      t.string :result_title
      t.boolean :clicked, default: false
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
    
    add_index :search_logs, :query
    add_index :search_logs, :clicked
    add_index :search_logs, :created_at
    add_index :search_logs, [:query, :clicked]
  end
end
