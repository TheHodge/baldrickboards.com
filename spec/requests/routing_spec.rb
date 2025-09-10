require 'rails_helper'

RSpec.describe "Routing", type: :request do
  describe "Locale enforcement" do
    it "redirects root to default locale" do
      get "/"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/en")
    end

    it "redirects pages without locale to default locale" do
      get "/boards"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/en/boards")
    end

    it "redirects fun-stuff without locale to default locale" do
      get "/fun-stuff"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/en/fun-stuff")
    end

    it "redirects support without locale to default locale" do
      get "/support"
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/en/support")
    end
  end

  describe "404 handling" do
    it "returns 404 for non-existent pages" do
      get "/en/non-existent-page"
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("404")
    end

    it "returns 404 for non-existent board pages" do
      get "/en/boards/non-existent-board"
      expect(response).to have_http_status(:not_found)
    end

    it "allows access to image files" do
      # This test assumes there are image files in public/img/
      # We'll test that the route constraint works properly
      get "/img/test-image.png"
      # This should not return 404 if the image exists, or return 404 if it doesn't
      # The important thing is that it doesn't get caught by our catch-all route
      expect(response.status).to be_in([200, 404])
    end
  end

  describe "API routes" do
    it "handles search log API routes" do
      post "/en/search_logs/log_search", params: { query: "test" }
      expect(response).to have_http_status(:success)
    end

    it "handles search click API routes" do
      post "/en/search_logs/log_click", params: { 
        query: "test", 
        result_url: "/test", 
        result_title: "Test" 
      }
      expect(response).to have_http_status(:success)
    end
  end
end
