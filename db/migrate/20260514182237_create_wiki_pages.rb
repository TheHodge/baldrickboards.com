class CreateWikiPages < ActiveRecord::Migration[8.0]
  def change
    create_table :wiki_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.references :parent, foreign_key: { to_table: :wiki_pages, on_delete: :nullify }, null: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :wiki_pages, :slug, unique: true
  end
end
