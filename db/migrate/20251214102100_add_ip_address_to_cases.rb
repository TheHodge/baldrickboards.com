class AddIpAddressToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :ip_address, :string
  end
end
