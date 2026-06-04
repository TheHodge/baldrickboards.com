require "rails_helper"

RSpec.describe Mattermost::Client do
  describe "#resolve_channel_id!" do
    it "returns the configured channel id when set" do
      allow(Mattermost::Config).to receive(:channel_id).and_return("channel-abc")
      client = described_class.new(bot_token: "test-bot-token")

      expect(client.resolve_channel_id!).to eq("channel-abc")
    end
  end

  describe "initialization" do
    it "requires a bot token" do
      expect { described_class.new(bot_token: nil) }.to raise_error(Mattermost::Client::Error, /token/)
    end
  end
end
