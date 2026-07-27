require "net/http"
require "json"

module BaldrickBuddy
  class GitHubClient
    class Error < StandardError; end

    def initialize(token: BaldrickBuddy::Config.github_token)
      raise Error, "GitHub token not configured" if token.blank?

      @token = token
    end

    def latest_release(owner:, repo:)
      get("/repos/#{owner}/#{repo}/releases/latest")
    end

    def release_asset_url(owner:, repo:, asset_id:)
      uri = URI("https://api.github.com/repos/#{owner}/#{repo}/releases/assets/#{asset_id}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{@token}"
      request["Accept"] = "application/octet-stream"
      request["X-GitHub-Api-Version"] = "2022-11-28"

      response = perform(uri, request)
      return response["location"] if response.is_a?(Net::HTTPRedirection)

      raise Error, "GitHub asset download failed (#{response.code})"
    end

    private

    def get(path)
      uri = URI("https://api.github.com#{path}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{@token}"
      request["Accept"] = "application/vnd.github+json"
      request["X-GitHub-Api-Version"] = "2022-11-28"

      response = perform(uri, request)
      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "GitHub API error (#{response.code}): #{response.body}"
      end

      JSON.parse(response.body)
    end

    def perform(uri, request)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
    end
  end
end
