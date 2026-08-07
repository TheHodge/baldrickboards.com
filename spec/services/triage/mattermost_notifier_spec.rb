require "rails_helper"

RSpec.describe Triage::MattermostNotifier do
  let!(:case_record) do
    Case.create!(
      name: "Test User",
      email: "test@example.com",
      problem_description: "Test problem description for mattermost",
      baldrick_version: "1.0.0",
      status: "open",
      todoist_task_id: "task-456"
    )
  end

  let(:client) { instance_double(Mattermost::Client) }

  before do
    allow(Mattermost::Config).to receive(:enabled?).and_return(true)
    allow(Mattermost::Client).to receive(:new).and_return(client)
    allow(Todoist::TaskLink).to receive(:url_for).and_return("https://app.todoist.com/app/task/task-456")
  end

  describe ".case_created" do
    it "posts a new case message and stores the root post id" do
      expect(client).to receive(:create_post!).with(
        message: a_string_including("New Christmas Triage case", "Open in Todoist"),
        root_id: nil
      ).and_return({ "id" => "root-post-1" })

      described_class.case_created(case_record)

      expect(case_record.reload.mattermost_root_post_id).to eq("root-post-1")
    end

    it "does nothing when Mattermost is disabled" do
      allow(Mattermost::Config).to receive(:enabled?).and_return(false)
      expect(client).not_to receive(:create_post!)

      described_class.case_created(case_record)
    end

    it "does nothing without a Todoist task id" do
      case_record.update_column(:todoist_task_id, nil)
      expect(client).not_to receive(:create_post!)

      described_class.case_created(case_record)
    end
  end

  describe ".case_updated" do
    it "posts a thread reply when a root post id exists" do
      case_record.update_column(:mattermost_root_post_id, "root-post-1")
      case_record.update!(status: "closed")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("updated", "Status", "closed"),
        root_id: "root-post-1"
      ).and_return({ "id" => "reply-1" })

      described_class.case_updated(case_record)
      expect(case_record.reload.mattermost_root_post_id).to eq("root-post-1")
    end

    it "starts a thread root when no root post id exists yet" do
      case_record.update!(status: "closed")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("updated", "Status", "closed"),
        root_id: nil
      ).and_return({ "id" => "legacy-root-1" })

      described_class.case_updated(case_record)
      expect(case_record.reload.mattermost_root_post_id).to eq("legacy-root-1")
    end

    it "falls back to a new root when the stored thread root is rejected" do
      case_record.update_column(:mattermost_root_post_id, "missing-root")
      case_record.update!(status: "closed")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("updated"),
        root_id: "missing-root"
      ).and_raise(Mattermost::Client::Error, "Mattermost API error (400): root not found")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("updated"),
        root_id: nil
      ).and_return({ "id" => "fallback-root-1" })

      described_class.case_updated(case_record)
      expect(case_record.reload.mattermost_root_post_id).to eq("fallback-root-1")
    end

    it "skips when only ignored fields changed" do
      expect(client).not_to receive(:create_post!)

      described_class.case_updated(
        case_record,
        changes: {
          "todoist_synced_at" => [nil, Time.current],
          "mattermost_root_post_id" => [nil, "root-post-1"]
        }
      )
    end
  end

  describe ".comment_added" do
    let(:comment) do
      case_record.case_comments.create!(
        content: "Please check the logs",
        admin_name: "Baldrick Team"
      )
    end

    it "posts a comment as a thread reply" do
      case_record.update_column(:mattermost_root_post_id, "root-post-1")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("New comment", "Baldrick Team", "Please check the logs"),
        root_id: "root-post-1"
      ).and_return({ "id" => "reply-2" })

      described_class.comment_added(case_record, comment)
    end
  end
end
