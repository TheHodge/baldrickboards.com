require 'rails_helper'

RSpec.describe "Admin", type: :request do
  describe "Admin access control" do
    context "when not authenticated" do
      it "redirects admin dashboard to login" do
        get "/en/admin"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin newsletter subscribers to login" do
        get "/en/admin/newsletter-subscribers"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin feedback to login" do
        get "/en/admin/feedbacks"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin search logs to login" do
        get "/en/admin/search-logs"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin knowledge to login" do
        get "/en/admin/knowledge"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects knowledge formatting guide to login" do
        get "/en/admin/knowledge/help"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end
    end

    context "when authenticated as admin" do
      before do
        allow_any_instance_of(Admin::BaseController).to receive(:authenticate_admin!).and_return(true)
      end

      it "allows access to admin dashboard" do
        get "/en/admin"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Admin Dashboard")
      end

      it "allows access to admin newsletter subscribers" do
        get "/en/admin/newsletter-subscribers"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Newsletter Subscribers")
      end

      it "allows access to admin feedback" do
        get "/en/admin/feedbacks"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Feedback Management")
      end

      it "allows access to admin search logs" do
        get "/en/admin/search-logs"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Search Analytics")
      end

      it "allows access to admin knowledge" do
        get "/en/admin/knowledge"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Internal knowledge")
      end

      it "allows access to knowledge formatting guide" do
        get "/en/admin/knowledge/help"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Knowledge formatting guide")
      end

      it "prefills new knowledge page when following a broken wiki link" do
        WikiPage.destroy_all
        boards = WikiPage.create!(title: "Boards", position: 0)
        get "/en/admin/knowledge/new", params: { missing_wiki_target: "#{boards.slug}/baldrick8" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Creating a page for a link that does not exist yet")
        expect(response.body).to include("[[#{boards.slug}/baldrick8]]")
        expect(response.body.scan('value="Baldrick8"').size).to eq(1)
      end
    end
  end

  describe "Admin login" do
    it "loads admin login page" do
      get "/en/admin/login"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Login")
    end

    it "handles admin login POST request" do
      post "/en/admin/login", params: { password: "wrong-password" }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "handles admin logout" do
      delete "/en/admin/logout"
      expect(response).to have_http_status(:redirect)
    end
  end
end
