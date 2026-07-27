require "rails_helper"

RSpec.describe "Baldrick Buddy API", type: :request do
  let(:release) do
    BaldrickBuddy::Release.new(
      tag_name: "v0.3.9",
      version: "0.3.9",
      published_at: Time.zone.parse("2026-07-20T14:30:00Z"),
      body: "Notes",
      assets: [
        BaldrickBuddy::Asset.new(id: 123, name: "buddy-mac.dmg", size: 1000, platform: "mac"),
        BaldrickBuddy::Asset.new(id: 456, name: "buddy-win.exe", size: 2000, platform: "windows")
      ]
    )
  end

  before do
    allow(BaldrickBuddy::Config).to receive(:enabled?).and_return(true)
    allow(BaldrickBuddy::ReleaseFetcher).to receive(:fetch).and_return(release)
  end

  describe "GET /fun-stuff/baldrick-buddy/latest.json" do
    it "returns release metadata" do
      get "/fun-stuff/baldrick-buddy/latest.json"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["version"]).to eq("0.3.9")
      expect(json["platforms"]["mac"]["url"]).to include("/fun-stuff/baldrick-buddy/download/123")
    end

    it "returns service unavailable when release fetch fails" do
      allow(BaldrickBuddy::ReleaseFetcher).to receive(:fetch).and_return(nil)

      get "/fun-stuff/baldrick-buddy/latest.json"

      expect(response).to have_http_status(:service_unavailable)
      expect(JSON.parse(response.body)["error"]).to eq("releases_unavailable")
    end
  end

  describe "GET /fun-stuff/baldrick-buddy/download/:asset_id" do
    it "redirects to GitHub CDN for valid assets" do
      client = double(release_asset_url: "https://objects.githubusercontent.com/example")
      allow(BaldrickBuddy::GitHubClient).to receive(:new).and_return(client)
      allow(client).to receive(:release_asset_url).and_return("https://objects.githubusercontent.com/example")

      get "/fun-stuff/baldrick-buddy/download/123"

      expect(response).to redirect_to("https://objects.githubusercontent.com/example")
    end

    it "returns not found for unknown assets" do
      get "/fun-stuff/baldrick-buddy/download/999"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /en/fun-stuff/baldrick-buddy" do
    it "loads the page" do
      get fun_stuff_baldrick_buddy_path(locale: :en)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick Buddy")
      expect(response.body).to include("v0.3.9")
    end
  end
end
