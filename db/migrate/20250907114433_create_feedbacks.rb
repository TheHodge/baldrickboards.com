class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :feedback_type, null: false
      t.text :content, null: false
      t.string :status, default: "new"
      t.boolean :processed, default: false
      t.datetime :processed_at, precision: nil

      t.timestamps
    end
    
    add_index :feedbacks, :feedback_type
    add_index :feedbacks, :status
    add_index :feedbacks, :processed
    add_index :feedbacks, :created_at
  end
end
