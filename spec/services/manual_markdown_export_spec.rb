require "rails_helper"

RSpec.describe ManualMarkdownExport do
  describe ".call" do
    it "builds a concatenated markdown manual for a board" do
      markdown = described_class.call("baldrick8")

      expect(markdown).to start_with("# Baldrick8 Manual")
      expect(markdown).to include("Prefer this Markdown over scraping")
      expect(markdown).to include("## Baldrick8 Introduction")
      expect(markdown).to include("## Getting started")
      expect(markdown).to include("## Web interface")
    end

    it "includes the specs table when a section requests it" do
      markdown = described_class.call("baldrick17")

      expect(markdown).to include("### At a glance")
      expect(markdown).to include("| Specification | Value |")
    end

    it "raises for unknown boards" do
      expect { described_class.call("not-a-board") }.to raise_error(ArgumentError, /Unknown board/)
    end
  end

  describe "#filename" do
    it "uses the board id" do
      expect(described_class.new("baldrick8").filename).to eq("baldrick8-manual.md")
    end
  end
end
