class AddXlightsSummaryToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :xlights_summary, :jsonb
  end
end
