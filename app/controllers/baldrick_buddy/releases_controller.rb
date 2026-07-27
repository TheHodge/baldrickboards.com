module BaldrickBuddy
  class ReleasesController < ApplicationController
    skip_after_action :record_page_view

    def latest
      release = ReleaseFetcher.fetch

      unless release
        return render json: { error: "releases_unavailable" }, status: :service_unavailable
      end

      payload = ReleasePresenter.new(release, view_context: view_context).as_json
      expires_in 5.minutes, public: true
      render json: payload
    end
  end
end
