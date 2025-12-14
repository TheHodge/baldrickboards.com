class AddCustomSolutionToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :custom_solution, :text
  end
end
