module Mattermost
  module Config
    module_function

    def enabled?
      ENV.fetch("MATTERMOST_ENABLED", "false") == "true"
    end

    def base_url
      ENV.fetch("MATTERMOST_BASE_URL", "https://waffle.ilightthat.com").chomp("/")
    end

    def bot_token
      ENV["MATTERMOST_BOT_TOKEN"].presence || Rails.application.credentials[:mattermost_bot_token]
    end

    def channel_id
      ENV["MATTERMOST_CHANNEL_ID"].presence
    end

    def team_name
      ENV.fetch("MATTERMOST_TEAM_NAME", "ilightthat")
    end

    def channel_name
      ENV.fetch("MATTERMOST_CHANNEL_NAME", "christmas-triage")
    end
  end
end
