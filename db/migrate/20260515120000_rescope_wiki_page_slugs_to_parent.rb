class RescopeWikiPageSlugsToParent < ActiveRecord::Migration[8.0]
  def up
    remove_index :wiki_pages, name: "index_wiki_pages_on_slug"
    add_index :wiki_pages, :slug, unique: true, where: "parent_id IS NULL", name: "index_wiki_pages_slug_on_roots"
    add_index :wiki_pages, [:parent_id, :slug], unique: true, where: "parent_id IS NOT NULL", name: "index_wiki_pages_parent_and_slug"
  end

  def down
    remove_index :wiki_pages, name: "index_wiki_pages_slug_on_roots"
    remove_index :wiki_pages, name: "index_wiki_pages_parent_and_slug"
    add_index :wiki_pages, :slug, unique: true
  end
end
