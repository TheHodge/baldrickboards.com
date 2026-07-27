class Admin::BaldrickBuddyReleasesController < Admin::BaseController
  def purge
    BaldrickBuddy::ReleaseFetcher.purge_cache!
    release = BaldrickBuddy::ReleaseFetcher.fetch

    if release
      redirect_to admin_root_path,
        notice: "Baldrick Buddy release cache cleared. Now showing #{release.tag_name}."
    else
      redirect_to admin_root_path,
        alert: "Release cache cleared, but the latest release could not be fetched. Check GitHub credentials."
    end
  end
end
