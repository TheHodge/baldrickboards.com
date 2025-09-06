class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :subject, null: false
      t.text :message, null: false
      t.string :status, default: 'new'
      t.boolean :email_sent, default: false
      t.timestamp :email_sent_at

      t.timestamps
    end
    
    add_index :contacts, :status
    add_index :contacts, :email
    add_index :contacts, :created_at
  end
end
