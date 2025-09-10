class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Set locale from URL parameter
  before_action :set_locale

  # Custom 404 handling
  def not_found
    render 'errors/not_found', status: :not_found, layout: 'application'
  end

  private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale]
    else
      # Redirect to default locale to avoid duplicate content
      redirect_to url_for(locale: I18n.default_locale, only_path: false), status: :moved_permanently
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
