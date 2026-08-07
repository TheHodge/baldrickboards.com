require "rails_helper"

RSpec.describe Mattermost::Client do
  describe "#resolve_channel_id!" do
    it "returns the configured channel id when set" do
      allow(Mattermost::Config).to receive(:channel_id).and_return("channel-abc")
      client = described_class.new(bot_token: "test-bot-token")

      expect(client.resolve_channel_id!).to eq("channel-abc")
    end
  end

  describe "#create_post!" do
    let(:client) { described_class.new(bot_token: "test-bot-token") }
    let(:http) { instance_double(Net::HTTP) }
    let(:success_response) do
      instance_double(Net::HTTPSuccess, body: { id: "post-123" }.to_json, is_a?: true)
    end

    before do
      allow(Mattermost::Config).to receive(:channel_id).and_return("channel-abc")
      allow(Net::HTTP).to receive(:start).and_yield(http)
      allow(success_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
    end

    it "posts a top-level message without root_id" do
      expect(http).to receive(:request) do |request|
        payload = JSON.parse(request.body)
        expect(payload).to eq(
          "channel_id" => "channel-abc",
          "message" => "Hello"
        )
        success_response
      end

      expect(client.create_post!(message: "Hello")).to eq("id" => "post-123")
    end

    it "includes root_id for thread replies" do
      expect(http).to receive(:request) do |request|
        payload = JSON.parse(request.body)
        expect(payload).to eq(
          "channel_id" => "channel-abc",
          "message" => "Reply",
          "root_id" => "root-post-1"
        )
        success_response
      end

      expect(client.create_post!(message: "Reply", root_id: "root-post-1")).to eq("id" => "post-123")
    end
  end

  describe "initialization" do
    it "requires a bot token" do
      expect { described_class.new(bot_token: nil) }.to raise_error(Mattermost::Client::Error, /token/)
    end
  end
end

