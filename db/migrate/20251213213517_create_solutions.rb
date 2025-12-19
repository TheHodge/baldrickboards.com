class CreateSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solutions do |t|
      t.string :problem_keywords, array: true, default: []
      t.string :problem_title, null: false
      t.text :solution_text, null: false
      t.string :board_types, array: true, default: []
      t.boolean :active, default: true, null: false
      t.integer :match_count, default: 0, null: false
      t.integer :success_count, default: 0, null: false

      t.timestamps
    end

    add_index :solutions, :active
  end
end

