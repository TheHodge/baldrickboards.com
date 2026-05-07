require "rails_helper"

RSpec.describe "Todoist webhooks", type: :request do
  describe "verification endpoint" do
    it "returns ok for GET" do
      get "/integrations/todoist/webhook"
      expect(response).to have_http_status(:ok)
    end

    it "returns ok for HEAD" do
      head "/integrations/todoist/webhook"
      expect(response).to have_http_status(:ok)
    end
  end

  let!(:case_record) do
    Case.create!(
      name: "Webhook User",
      email: "webhook@example.com",
      problem_description: "Webhook test problem description",
      status: "open",
      baldrick_version: "1.0",
      todoist_task_id: "task-123"
    )
  end

  let(:payload_hash) do
    {
      event_id: "evt-1",
      event_name: event_name,
      event_data: {
        task_id: "task-123",
        content: "Please update firmware"
      }
    }
  end
  let(:payload) { payload_hash.to_json }
  let(:signature) { Base64.strict_encode64(OpenSSL::HMAC.digest("SHA256", "test-secret", payload)) }

  before do
    allow(Todoist::Config).to receive(:webhook_secret).and_return("test-secret")
    allow(TriageMailer).to receive(:admin_comment).and_return(double(deliver_now: true))
  end

  context "with comment webhook event" do
    let(:event_name) { "task:comment_added" }

    it "creates a case comment and returns success" do
      expect do
        post "/integrations/todoist/webhook",
             params: payload,
             headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }
      end.to change(CaseComment, :count).by(1)
        .and change(TodoistWebhookEvent, :count).by(1)

      expect(response).to have_http_status(:ok)
    end
  end

  context "with Todoist note:added payload shape" do
    let(:event_name) { "note:added" }
    let(:payload_hash) do
      {
        event_name: event_name,
        event_data: {
          item_id: "task-123",
          item: { id: "task-123" },
          content: "Todoist note payload comment"
        }
      }
    end

    it "maps item_id to case and creates comment" do
      expect do
        post "/integrations/todoist/webhook",
             params: payload,
             headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }
      end.to change(CaseComment, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(CaseComment.last.admin_name).to eq("Baldrick Team")
    end
  end

  context "with mirrored outbound sync comment" do
    let(:event_name) { "note:added" }
    let(:payload_hash) do
      {
        event_name: event_name,
        event_data: {
          item_id: "task-123",
          item: { id: "task-123" },
          content: "User reply from Dom Hodgson: Yep I've tried several times and nothing worked.."
        }
      }
    end

    it "ignores looped sync comments" do
      expect do
        post "/integrations/todoist/webhook",
             params: payload,
             headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }
      end.not_to change(CaseComment, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  context "with mirrored attachment sync comment" do
    let(:event_name) { "note:added" }
    let(:payload_hash) do
      {
        event_name: event_name,
        event_data: {
          item_id: "task-123",
          item: { id: "task-123" },
          content: "Attachment uploaded from Christmas Triage reply"
        }
      }
    end

    it "ignores looped sync attachment comments" do
      expect do
        post "/integrations/todoist/webhook",
             params: payload,
             headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }
      end.not_to change(CaseComment, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  context "with close webhook event" do
    let(:event_name) { "task:closed" }

    it "closes the case" do
      post "/integrations/todoist/webhook",
           params: payload,
           headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }

      expect(response).to have_http_status(:ok)
      expect(case_record.reload.status).to eq("closed")
    end
  end

  context "with reopen webhook event" do
    let(:event_name) { "task:reopened" }

    it "reopens the case" do
      case_record.update!(status: "closed")

      post "/integrations/todoist/webhook",
           params: payload,
           headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }

      expect(response).to have_http_status(:ok)
      expect(case_record.reload.status).to eq("open")
    end
  end

  context "with delete webhook event" do
    let(:event_name) { "task:deleted" }

    it "deletes the case" do
      expect do
        post "/integrations/todoist/webhook",
             params: payload,
             headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => signature }
      end.to change(Case, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  context "with invalid signature" do
    let(:event_name) { "task:comment_added" }

    it "rejects request" do
      post "/integrations/todoist/webhook",
           params: payload,
           headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => "wrong" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "with hex signature format" do
    let(:event_name) { "task:comment_added" }
    let(:hex_signature) { OpenSSL::HMAC.hexdigest("SHA256", "test-secret", payload) }

    it "accepts hex signature for compatibility" do
      post "/integrations/todoist/webhook",
           params: payload,
           headers: { "CONTENT_TYPE" => "application/json", "X-Todoist-Hmac-SHA256" => hex_signature }

      expect(response).to have_http_status(:ok)
    end
  end
end
