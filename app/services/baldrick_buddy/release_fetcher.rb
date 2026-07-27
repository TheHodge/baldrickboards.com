module BaldrickBuddy
  class ReleaseFetcher
    CACHE_KEY = "baldrick_buddy/latest_release"
    CACHE_TTL = 30.minutes

    PLATFORM_PRIORITY = {
      "mac" => %w[.dmg .pkg .zip],
      "windows" => %w[.msi .exe .zip],
      "linux" => %w[.appimage .deb .rpm .tar.gz]
    }.freeze

    class Error < StandardError; end

    def self.fetch
      new.fetch
    end

    def self.purge_cache!
      Rails.cache.delete(CACHE_KEY)
    end

    def fetch
      return nil unless Config.enabled?

      Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_TTL) do
        fetch_from_github
      end
    rescue Error => e
      Rails.logger.error("[BaldrickBuddy] Release fetch failed: #{e.message}")
      nil
    end

    def self.parse_payload(payload)
      new.send(:build_release, payload)
    end

    private

    def fetch_from_github
      payload = GitHubClient.new.latest_release(
        owner: Config.github_owner,
        repo: Config.github_repo
      )
      build_release(payload)
    end

    def build_release(payload)
      assets = parse_assets(payload.fetch("assets", []))

      BaldrickBuddy::Release.new(
        tag_name: payload.fetch("tag_name"),
        version: normalize_version(payload.fetch("tag_name")),
        published_at: Time.zone.parse(payload.fetch("published_at")),
        body: payload["body"],
        assets: assets
      )
    end

    def parse_assets(raw_assets)
      candidates = raw_assets.reject { |asset| source_archive?(asset) }

      PLATFORM_PRIORITY.flat_map do |platform, extensions|
        pick_asset(candidates, platform, extensions)
      end.compact
    end

    def pick_asset(candidates, platform, extensions)
      matching = candidates.select { |asset| platform_for(asset["name"]) == platform }
      return nil if matching.empty?

      chosen = extensions.lazy.map { |ext|
        matching.find { |asset| asset["name"].downcase.end_with?(ext) }
      }.find(&:itself) || matching.first

      BaldrickBuddy::Asset.new(
        id: chosen.fetch("id"),
        name: chosen.fetch("name"),
        size: chosen.fetch("size"),
        platform: platform
      )
    end

    def source_archive?(asset)
      name = asset.fetch("name")
      name.start_with?("Source code") ||
        (asset["content_type"] == "application/gzip" && name.include?("Source code"))
    end

    def platform_for(filename)
      down = filename.downcase

      return "mac" if down.end_with?(".dmg", ".pkg") || down.include?("-mac-") || down.include?("-darwin-")
      return "windows" if down.end_with?(".exe", ".msi") || down.include?("-win-")
      return "linux" if down.end_with?(".appimage", ".deb", ".rpm") || down.include?("-linux-")

      nil
    end

    def normalize_version(tag_name)
      tag_name.delete_prefix("v")
    end
  end
end
