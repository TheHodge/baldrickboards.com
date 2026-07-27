require "rails_helper"

RSpec.describe BaldrickBuddy::ReleaseFetcher do
  describe ".parse_payload" do
    let(:payload) do
      {
        "tag_name" => "v0.3.9",
        "published_at" => "2026-07-20T14:30:00Z",
        "body" => "Release notes",
        "assets" => [
          { "id" => 1, "name" => "Source code (zip)", "size" => 100, "content_type" => "application/zip" },
          { "id" => 2, "name" => "Baldrick-Buddy-0.3.9-mac-universal.dmg", "size" => 85_000_000, "content_type" => "application/octet-stream" },
          { "id" => 3, "name" => "Baldrick-Buddy-0.3.9-win-x64.exe", "size" => 72_000_000, "content_type" => "application/octet-stream" },
          { "id" => 4, "name" => "Baldrick-Buddy-0.3.9-linux-x64.AppImage", "size" => 91_000_000, "content_type" => "application/octet-stream" }
        ]
      }
    end

    it "parses version and filters source archives" do
      release = described_class.parse_payload(payload)

      expect(release.version).to eq("0.3.9")
      expect(release.tag_name).to eq("v0.3.9")
      expect(release.assets.map(&:platform)).to eq(%w[mac windows linux])
      expect(release.assets.map(&:id)).to eq([2, 3, 4])
    end
  end
end
