require "rails_helper"

RSpec.describe Todoist::CaseSync do
  let(:client) { instance_double(Todoist::Client) }

  before do
    allow(Todoist::Config).to receive(:enabled?).and_return(true)
    allow(Todoist::Config).to receive(:workspace_name).and_return("iLightThat")
    allow(Todoist::Config).to receive(:project_name).and_return("Support Issues")
    allow(Todoist::Config).to receive(:needs_reply_label).and_return("triage-needs-reply")

    allow(Todoist::Client).to receive(:new).and_return(client)
    allow(client).to receive(:resolve_project_id!).and_return("project-1")
    allow(client).to receive(:create_task!).and_return({ "id" => "task-1" })
    allow(client).to receive(:get_task!).and_return({ "labels" => [] })
    allow(client).to receive(:update_task!)
    allow(client).to receive(:upload_file!).and_return({ "file_url" => "https://files.example.com/debug.json" })
    allow(client).to receive(:create_comment!)
    allow(client).to receive(:close_task!)
  end

  describe ".sync_create" do
    let!(:case_record) do
      Case.create!(
        name: "Test User",
        email: "test@example.com",
        problem_description: "Board is not responding after power cycle",
        baldrick_version: "1.0.0",
        status: "open"
      )
    end

    it "uploads the debugging file to Todoist as an attachment" do
      case_record.debugging_file.attach(
        io: StringIO.new('{"state":{"board_model":"Baldrick8"}}'),
        filename: "debug.json",
        content_type: "application/json"
      )

      described_class.sync_create(case_record)

      expect(client).to have_received(:upload_file!)
      expect(client).to have_received(:create_comment!).with(
        hash_including(
          task_id: "task-1",
          content: "Debugging file attached from Christmas Triage"
        )
      )
    end
  end

  describe ".sync_solution" do
    let!(:case_record) do
      Case.create!(
        name: "Test User",
        email: "test@example.com",
        problem_description: "Board is not responding after power cycle",
        baldrick_version: "1.0.0",
        status: "solved",
        custom_solution: "I had the board replaced, as it was faulty from manufacturing.",
        todoist_task_id: "task-1"
      )
    end

    it "posts the custom solution as a Todoist comment" do
      described_class.sync_solution(case_record)

      expect(client).to have_received(:create_comment!).with(
        task_id: "task-1",
        content: "Solution from Christmas Triage: I had the board replaced, as it was faulty from manufacturing."
      )
    end

    it "posts a selected solution title and text as a Todoist comment" do
      solution = Solution.create!(
        problem_title: "Faulty board from manufacturing",
        solution_text: "Replace the board under warranty.",
        problem_keywords: %w[board faulty manufacturing]
      )
      case_record.update!(custom_solution: nil, solved_by_solution_id: solution.id)

      described_class.sync_solution(case_record)

      expect(client).to have_received(:create_comment!).with(
        task_id: "task-1",
        content: "Solution from Christmas Triage (Faulty board from manufacturing): Replace the board under warranty."
      )
    end

    it "does nothing when there is no solution text" do
      case_record.update!(custom_solution: nil, solved_by_solution_id: nil)

      described_class.sync_solution(case_record)

      expect(client).not_to have_received(:create_comment!)
    end
  end
end
