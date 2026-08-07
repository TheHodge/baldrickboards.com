class AddMattermostRootPostIdToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :mattermost_root_post_id, :string
    add_index :cases, :mattermost_root_post_id
  end
end
