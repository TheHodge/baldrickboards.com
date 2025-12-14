class AddForeignKeyToCases < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :cases, :solutions, column: :solved_by_solution_id
  end
end
