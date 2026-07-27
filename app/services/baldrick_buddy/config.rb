module BaldrickBuddy
  # Reads GitHub Releases config from ENV or Rails credentials:
  #
  #   BALDRICK_BUDDY_GITHUB_TOKEN   — fine-grained PAT, Contents read-only
  #   BALDRICK_BUDDY_GITHUB_OWNER   — e.g. TheHodge
  #   BALDRICK_BUDDY_GITHUB_REPO    — e.g. baldrick_buddy
  #
  # Optional: BALDRICK_BUDDY_RELEASES_ENABLED=false to disable fetches in dev.
  module Config
    module_function

    def enabled?
      ENV.fetch("BALDRICK_BUDDY_RELEASES_ENABLED", "true") == "true" &&
        github_token.present? &&
        github_owner.present? &&
        github_repo.present?
    end

    def github_token
      ENV["BALDRICK_BUDDY_GITHUB_TOKEN"].presence ||
        Rails.application.credentials[:baldrick_buddy_github_token]
    end

    def github_owner
      ENV["BALDRICK_BUDDY_GITHUB_OWNER"].presence ||
        Rails.application.credentials[:baldrick_buddy_github_owner]
    end

    def github_repo
      ENV["BALDRICK_BUDDY_GITHUB_REPO"].presence ||
        Rails.application.credentials[:baldrick_buddy_github_repo]
    end
  end
end
