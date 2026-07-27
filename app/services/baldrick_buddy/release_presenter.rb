module BaldrickBuddy
  class ReleasePresenter
    PLATFORM_LABELS = {
      "mac" => "macOS",
      "windows" => "Windows",
      "linux" => "Linux"
    }.freeze

    def initialize(release, view_context:)
      @release = release
      @view_context = view_context
    end

    def as_json
      {
        name: "Baldrick Buddy",
        version: @release.version,
        tag_name: @release.tag_name,
        published_at: @release.published_at.iso8601,
        release_page: @view_context.fun_stuff_baldrick_buddy_url(locale: I18n.default_locale),
        platforms: platform_payload
      }
    end

    private

    def platform_payload
      PLATFORM_LABELS.each_with_object({}) do |(platform, _), payload|
        asset = @release.asset_for(platform)
        next unless asset

        payload[platform] = {
          url: @view_context.baldrick_buddy_download_url(asset_id: asset.id, locale: nil),
          filename: asset.name,
          size: asset.size
        }
      end
    end
  end
end
