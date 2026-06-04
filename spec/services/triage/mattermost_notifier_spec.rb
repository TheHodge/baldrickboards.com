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

  let(:client) { instance_double(Mattermost::Client, create_post!: { "id" => "post-1" }) }

  before do
    allow(Mattermost::Config).to receive(:enabled?).and_return(true)
    allow(Mattermost::Client).to receive(:new).and_return(client)
    allow(Todoist::TaskLink).to receive(:url_for).and_return("https://app.todoist.com/app/task/task-456")
  end

  describe ".case_created" do
    it "posts a new case message" do
      expect(client).to receive(:create_post!).with(
        message: a_string_including("New Christmas Triage case", "Open in Todoist")
      )

      described_class.case_created(case_record)
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
    it "posts when there are meaningful changes" do
      case_record.update!(status: "closed")

      expect(client).to receive(:create_post!).with(
        message: a_string_including("updated", "Status", "closed")
      )

      described_class.case_updated(case_record)
    end

    it "skips when only ignored fields changed" do
      case_record.update_columns(todoist_synced_at: Time.current)

      expect(client).not_to receive(:create_post!)

      described_class.case_updated(case_record)
    end
  end

  describe ".comment_added" do
    let(:comment) do
      case_record.case_comments.create!(
        content: "Please check the logs",
        admin_name: "Baldrick Team"
      )
    end

    it "posts a comment message" do
      expect(client).to receive(:create_post!).with(
        message: a_string_including("New comment", "Baldrick Team", "Please check the logs")
      )

      described_class.comment_added(case_record, comment)
    end
  end
end
