require "rails_helper"

RSpec.describe Todoist::TaskLink do
  let!(:case_record) do
    Case.create!(
      name: "Test User",
      email: "test@example.com",
      problem_description: "Test problem description",
      baldrick_version: "1.0.0",
      status: "open",
      todoist_task_id: "task-789"
    )
  end

  it "returns nil without a task id" do
    case_record.update_column(:todoist_task_id, nil)
    expect(described_class.url_for(case_record)).to be_nil
  end

  it "uses the Todoist API url when available" do
    allow(Todoist::Config).to receive(:enabled?).and_return(true)
    allow(Todoist::Config).to receive(:api_token).and_return("token")
    client = instance_double(Todoist::Client)
    allow(Todoist::Client).to receive(:new).and_return(client)
    allow(client).to receive(:get_task!).with(task_id: "task-789")
      .and_return({ "url" => "https://app.todoist.com/app/task/v2-id" })

    expect(described_class.url_for(case_record)).to eq("https://app.todoist.com/app/task/v2-id")
  end

  it "falls back when the API is unavailable" do
    allow(Todoist::Config).to receive(:enabled?).and_return(false)

    expect(described_class.url_for(case_record)).to eq("https://app.todoist.com/app/task/task-789")
  end
end
