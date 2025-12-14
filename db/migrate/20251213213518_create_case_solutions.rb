class CreateCaseSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :case_solutions do |t|
      t.references :case, null: false, foreign_key: true
      t.references :solution, null: false, foreign_key: true
      t.integer :match_score, null: false
      t.datetime :presented_at

      t.timestamps
    end

    add_index :case_solutions, [:case_id, :solution_id], unique: true
    add_index :case_solutions, :match_score
  end
end
