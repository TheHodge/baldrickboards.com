module BaldrickBuddy
  class DownloadsController < ApplicationController
    skip_after_action :record_page_view

    def show
      release = ReleaseFetcher.fetch
      asset = release&.assets&.find { |a| a.id.to_s == params[:asset_id].to_s }
      return head :not_found unless asset

      location = GitHubClient.new.release_asset_url(
        owner: Config.github_owner,
        repo: Config.github_repo,
        asset_id: params[:asset_id]
      )

      redirect_to location, allow_other_host: true
    rescue GitHubClient::Error => e
      Rails.logger.error("[BaldrickBuddy] Download failed: #{e.message}")
      head :bad_gateway
    end
  end
end
