require "rails_helper"

RSpec.describe WikiPage, type: :model do
  describe ".find_for_wiki_link" do
    before do
      WikiPage.destroy_all
    end

    let!(:page) { WikiPage.create!(title: "Setup Guide", position: 0) }

    it "finds by exact slug" do
      expect(WikiPage.find_for_wiki_link(page.slug)).to eq(page)
    end

    it "finds by title-like string matching slug parameterization" do
      expect(WikiPage.find_for_wiki_link("Setup Guide")).to eq(page)
    end

    it "finds by case-insensitive title" do
      expect(WikiPage.find_for_wiki_link("setup guide")).to eq(page)
    end

    it "returns nil when unknown" do
      expect(WikiPage.find_for_wiki_link("missing-page")).to be_nil
    end

    it "finds nested page by full path" do
      parent = WikiPage.create!(title: "Boards", position: 0)
      child = WikiPage.create!(title: "Baldrick8", parent: parent, position: 0)
      expect(WikiPage.find_for_wiki_link("#{parent.slug}/#{child.slug}")).to eq(child)
    end
  end

  describe ".find_by_url_path" do
    before { WikiPage.destroy_all }

    it "walks parent chain" do
      parent = WikiPage.create!(title: "Boards", position: 0)
      child = WikiPage.create!(title: "Baldrick8", parent: parent, position: 0)
      expect(WikiPage.find_by_url_path("#{parent.slug}/#{child.slug}")).to eq(child)
    end

    it "returns nil for unknown segment" do
      expect(WikiPage.find_by_url_path("nope")).to be_nil
    end
  end

  describe "#url_path" do
    before { WikiPage.destroy_all }

    it "joins ancestor slugs" do
      parent = WikiPage.create!(title: "Boards", position: 0)
      child = WikiPage.create!(title: "Baldrick8", parent: parent, position: 0)
      expect(child.url_path).to eq("#{parent.slug}/#{child.slug}")
    end
  end

  describe "slug uniqueness per parent" do
    before { WikiPage.destroy_all }

    it "allows same slug under different parents" do
      a = WikiPage.create!(title: "Section A", position: 0)
      b = WikiPage.create!(title: "Section B", position: 0)
      WikiPage.create!(title: "Child", parent: a, position: 0)
      expect { WikiPage.create!(title: "Child", parent: b, position: 0) }.not_to raise_error
    end

    it "auto-uniqueifies slug among siblings with the same title" do
      parent = WikiPage.create!(title: "Boards", position: 0)
      WikiPage.create!(title: "Same Title", parent: parent, position: 0)
      other = WikiPage.create!(title: "Same Title", parent: parent, position: 1)
      expect(other.slug).to eq("same-title-2")
    end
  end

  describe ".new_from_missing_wiki_target" do
    before { WikiPage.destroy_all }

    it "prefills title from a single segment" do
      page = WikiPage.new_from_missing_wiki_target("my-new-page")
      expect(page.title).to eq("My New Page")
      expect(page.parent_id).to be_nil
    end

    it "sets parent when the path prefix exists" do
      boards = WikiPage.create!(title: "Boards", position: 0)
      page = WikiPage.new_from_missing_wiki_target("#{boards.slug}/baldrick8")
      expect(page.parent_id).to eq(boards.id)
      expect(page.title).to eq("Baldrick8")
    end

    it "strips disallowed characters from the param" do
      page = WikiPage.new_from_missing_wiki_target("safe-page<script>")
      expect(page.title).to eq("Safe Pagescript")
    end
  end

  describe ".sanitize_missing_wiki_target_param" do
    it "returns empty for blank" do
      expect(WikiPage.sanitize_missing_wiki_target_param("")).to eq("")
    end
  end

  describe "reserved slugs" do
    before { WikiPage.destroy_all }

    it "rejects help at root" do
      page = WikiPage.new(title: "Help", position: 0)
      expect(page).not_to be_valid
      expect(page.errors[:slug]).to be_present
    end
  end
end
