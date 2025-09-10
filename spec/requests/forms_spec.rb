require 'rails_helper'

RSpec.describe "Forms", type: :request do
  describe "Contact form" do
    # Note: Contact form doesn't have a GET route, only POST
    
    it "submits contact form successfully" do
      # Mock the mailers to avoid SMTP connection issues
      allow(ContactMailer).to receive(:contact_submission).and_return(double(deliver_now: true))
      allow(ContactMailer).to receive(:contact_confirmation).and_return(double(deliver_now: true))
      
      post contacts_path(locale: :en), params: {
        contact: {
          name: "Test User",
          email: "test@example.com",
          subject: "Test Subject",
          message: "Test message content"
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/en/support")
    end

    it "handles contact form validation errors" do
      post contacts_path(locale: :en), params: {
        contact: {
          name: "",
          email: "invalid-email",
          subject: "",
          message: ""
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "Feedback form" do
    it "loads feedback form" do
      get new_feedback_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Feedback")
    end

    it "submits feedback form successfully" do
      # Mock the mailer to avoid SMTP connection issues
      allow(FeedbackMailer).to receive(:new_feedback).and_return(double(deliver_now: true))
      
      post feedback_path(locale: :en), params: {
        feedback: {
          name: "Test User",
          email: "test@example.com",
          feedback_type: "testimonial",
          content: "This is a test testimonial"
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/en/feedback/success")
    end

    it "handles feedback form validation errors" do
      post feedback_path(locale: :en), params: {
        feedback: {
          name: "",
          email: "invalid-email",
          feedback_type: "",
          content: ""
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "Newsletter subscription" do
    it "subscribes to newsletter successfully" do
      post newsletter_subscribers_path(locale: :en), params: {
        newsletter_subscriber: {
          email: "test@example.com"
        }
      }
      expect(response).to have_http_status(:redirect)
    end

    it "handles newsletter subscription validation errors" do
      post newsletter_subscribers_path(locale: :en), params: {
        newsletter_subscriber: {
          email: "invalid-email"
        }
      }
      # Newsletter subscription redirects on validation errors instead of returning 422
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "Search logging" do
    it "logs search query" do
      post "/search_logs/log_search", params: {
        query: "test search"
      }
      # Search logs now work without locale redirect
      expect(response).to have_http_status(:success)
    end

    it "logs search click" do
      post "/search_logs/log_click", params: {
        query: "test search",
        result_url: "/en/boards/baldrick8",
        result_title: "Baldrick8"
      }
      # Search logs now work without locale redirect
      expect(response).to have_http_status(:success)
    end
  end
end
