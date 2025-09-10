require 'rails_helper'

RSpec.describe "Admin", type: :request do
  describe "Admin access control" do
    context "when not authenticated" do
      it "redirects admin dashboard to login" do
        get "/admin"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin newsletter subscribers to login" do
        get "/admin/newsletter-subscribers"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin feedback to login" do
        get "/admin/feedbacks"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end

      it "redirects admin search logs to login" do
        get "/admin/search-logs"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/admin/login")
      end
    end

    context "when authenticated as admin" do
      before do
        # Mock admin authentication
        allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
      end

      it "allows access to admin dashboard" do
        get "/admin"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Admin Dashboard")
      end

      it "allows access to admin newsletter subscribers" do
        get "/admin/newsletter-subscribers"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Newsletter Subscribers")
      end

      it "allows access to admin feedback" do
        get "/admin/feedbacks"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Feedback Management")
      end

      it "allows access to admin search logs" do
        get "/admin/search-logs"
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Search Analytics")
      end
    end
  end

  describe "Admin login" do
    it "loads admin login page" do
      get "/admin/login"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Login")
    end

    it "handles admin login POST request" do
      post "/admin/login", params: { session: { password: "test" } }
      # This will likely redirect or show an error, but we're testing the route exists
      expect(response).to have_http_status(:redirect)
    end

    it "handles admin logout" do
      delete "/admin/logout"
      expect(response).to have_http_status(:redirect)
    end
  end
end
