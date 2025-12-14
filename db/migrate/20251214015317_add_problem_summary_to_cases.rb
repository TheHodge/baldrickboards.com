class AddProblemSummaryToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :problem_summary, :text
  end
end
