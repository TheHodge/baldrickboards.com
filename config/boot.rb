ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Prevent ruby-vips from being loaded (it requires libvips which isn't installed)
# This must be done before image_processing tries to load it
module Kernel
  alias_method :original_require, :require
  def require(name)
    return false if name == 'vips' || name == 'ruby-vips' || name == 'image_processing/vips'
    original_require(name)
  end
end

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
