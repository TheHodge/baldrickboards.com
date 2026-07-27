module BaldrickBuddy
  Release = Struct.new(:tag_name, :version, :published_at, :body, :assets, keyword_init: true) do
    def asset_for(platform)
      assets.find { |asset| asset.platform == platform.to_s }
    end

    def platforms
      assets.map(&:platform).uniq
    end
  end
end
