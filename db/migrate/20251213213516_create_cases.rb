class CreateCases < ActiveRecord::Migration[8.0]
  def change
    create_table :cases do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.bigint :user_id, null: true # Future foreign key to users table
      t.text :problem_description, null: false
      t.text :tried_solutions
      t.integer :knowledge_level
      t.string :status, default: 'open', null: false
      t.string :access_token, null: false
      t.string :access_code, null: false
      t.string :affected_boards, array: true, default: []
      t.string :baldrick_version
      t.string :fpp_version
      t.string :xlights_version
      t.string :operating_system
      t.text :system_state
      t.text :fpp_outputs_state
      t.bigint :solved_by_solution_id
      t.integer :case_number, null: false

      t.timestamps
    end

    add_index :cases, :access_token, unique: true
    add_index :cases, :case_number, unique: true
    add_index :cases, :status
    add_index :cases, :user_id
    add_index :cases, :email
    # Foreign key to solutions will be added after solutions table is created
  end
end

