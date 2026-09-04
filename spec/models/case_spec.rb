require "rails_helper"

RSpec.describe Case do
  def build_case
    described_class.create!(
      name: "Test User",
      email: "test@example.com",
      problem_description: "This is a test problem description",
      baldrick_version: "1.0.0",
      status: "open"
    )
  end

  it "purges the xLights zip when the case is closed but keeps the parsed summary" do
    case_record = build_case
    case_record.xlights_show_folder.attach(
      io: StringIO.new("zip-bytes"),
      filename: "show.zip",
      content_type: "application/zip"
    )
    case_record.update_column(:xlights_summary, { "controllers" => [{ "name" => "B17-5" }] })

    case_record.update!(status: "closed")

    expect(case_record.reload.xlights_show_folder).not_to be_attached
    expect(case_record.xlights_summary["controllers"].first["name"]).to eq("B17-5")
  end

  it "keeps the xLights zip when the case is marked solved" do
    case_record = build_case
    case_record.xlights_show_folder.attach(
      io: StringIO.new("zip-bytes"),
      filename: "show.zip",
      content_type: "application/zip"
    )

    case_record.update!(status: "solved")

    expect(case_record.reload.xlights_show_folder).to be_attached
  end
end
