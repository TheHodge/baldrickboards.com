namespace :mattermost do
  desc "Smoke test: verify bot auth, resolve christmas-triage channel, and post a threaded test message"
  task smoke_test: :environment do
    unless Mattermost::Config.bot_token.present?
      abort "Set MATTERMOST_BOT_TOKEN (or credentials mattermost_bot_token) before running."
    end

    client = Mattermost::Client.new
    user = client.me
    puts "Authenticated as: #{user['username']} (#{user['id']})"

    channel_id = client.resolve_channel_id!
    puts "Channel id: #{channel_id}"

    root = client.create_post!(
      channel_id: channel_id,
      message: "Christmas Triage Mattermost smoke test root (#{Time.current.iso8601})"
    )
    puts "Posted root message id: #{root['id']}"

    reply = client.create_post!(
      channel_id: channel_id,
      root_id: root.fetch("id"),
      message: "Christmas Triage Mattermost smoke test thread reply"
    )
    puts "Posted thread reply id: #{reply['id']} (root_id=#{reply['root_id']})"
    puts "Smoke test succeeded."
  rescue Mattermost::Client::Error => e
    abort "Smoke test failed: #{e.message}"
  end
end
