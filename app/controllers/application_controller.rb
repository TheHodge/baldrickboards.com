class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Custom 404 handling
  def not_found
    render 'errors/not_found', status: :not_found, layout: 'application'
  end
end
