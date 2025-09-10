class CreateErrorLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :error_logs do |t|
      t.string :url
      t.string :referrer
      t.string :user_agent
      t.string :ip
      t.integer :count
      t.datetime :last_seen

      t.timestamps
    end
  end
end
