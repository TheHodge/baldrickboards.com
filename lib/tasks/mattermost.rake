namespace :mattermost do
  desc "Smoke test: verify bot auth, resolve christmas-triage channel, and post a test message"
  task smoke_test: :environment do
    unless Mattermost::Config.bot_token.present?
      abort "Set MATTERMOST_BOT_TOKEN (or credentials mattermost_bot_token) before running."
    end

    client = Mattermost::Client.new
    user = client.me
    puts "Authenticated as: #{user['username']} (#{user['id']})"

    channel_id = client.resolve_channel_id!
    puts "Channel id: #{channel_id}"

    post = client.create_post!(
      channel_id: channel_id,
      message: "Christmas Triage Mattermost smoke test (#{Time.current.iso8601})"
    )
    puts "Posted message id: #{post['id']}"
    puts "Smoke test succeeded."
  rescue Mattermost::Client::Error => e
    abort "Smoke test failed: #{e.message}"
  end
end
