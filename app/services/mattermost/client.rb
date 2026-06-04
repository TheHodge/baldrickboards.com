require "net/http"
require "json"

module Mattermost
  class Client
    class Error < StandardError; end

    def initialize(bot_token: Mattermost::Config.bot_token, base_url: Mattermost::Config.base_url)
      raise Error, "Mattermost bot token not configured" if bot_token.blank?

      @bot_token = bot_token
      @base_url = base_url
    end

    def me
      get("/api/v4/users/me")
    end

    def resolve_channel_id!
      return Mattermost::Config.channel_id if Mattermost::Config.channel_id.present?

      team = get("/api/v4/teams/name/#{Mattermost::Config.team_name}")
      channel = get(
        "/api/v4/teams/#{team.fetch('id')}/channels/name/#{Mattermost::Config.channel_name}"
      )
      channel.fetch("id")
    end

    def create_post!(message:, channel_id: nil)
      channel_id ||= resolve_channel_id!
      post_json("/api/v4/posts", {
        channel_id: channel_id,
        message: message
      })
    end

    private

    def get(path)
      uri = URI("#{@base_url}#{path}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{@bot_token}"

      parsed_response(request, uri)
    end

    def post_json(path, payload)
      uri = URI("#{@base_url}#{path}")
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{@bot_token}"
      request["Content-Type"] = "application/json"
      request.body = payload.to_json

      parsed_response(request, uri)
    end

    def parsed_response(request, uri)
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "Mattermost API error (#{response.code}): #{response.body}"
      end

      return {} if response.body.blank?

      JSON.parse(response.body)
    end
  end
end
