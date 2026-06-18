require "rails_helper"

RSpec.describe BoardsHelper, type: :helper do
  describe "#board_manual_sections" do
    it "discovers numbered markdown files in sort order" do
      sections = helper.board_manual_sections("baldrick8")

      expect(sections.map { |s| s[:slug] }).to eq(%w[introduction board_tour getting_started web_interface])
      expect(sections.first[:title]).to eq("Baldrick8 Introduction")
      expect(sections.third[:title]).to eq("Getting started")
    end

    it "only includes files that exist for each board" do
      sections = helper.board_manual_sections("baldrickbadge")

      expect(sections.map { |s| s[:slug] }).to eq(%w[getting_started tech_specs])
    end

    it "returns the latest manual file mtime" do
      updated = helper.board_manual_updated_at("baldrick8")

      expect(updated).to be_a(Time)
      expect(updated).to be >= helper.board_manual_entries("baldrick8").first[:path].mtime
    end

    it "formats the updated label" do
      expect(helper.board_manual_updated_label("baldrick8")).to match(/\A\d{1,2} \w{3} \d{4}\z/)
    end
  end
end
