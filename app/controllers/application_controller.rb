class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Ahoy analytics tracking will be implemented directly

  # Set locale from URL parameter
  before_action :set_locale
  
  # Record page views for analytics
  after_action :record_page_view

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
  
  def record_page_view
    # Record page views for analytics with Ahoy
    # Only record HTML responses and skip admin pages
    if should_track_page?
      begin
        # Extract page title from response body
        title = response.body.match(/<title>(.*?)<\/title>/m)&.captures&.first || "Unknown Page"
        
        # Create or find visit
        visit = find_or_create_visit
        
        # Track the page view event
        Ahoy::Event.create!(
          visit: visit,
          name: "Page view",
          properties: {
            title: title,
            url: request.url,
            path: request.path,
            referrer: request.referrer
          },
          time: Time.current
        )
      rescue => e
        # Log error but don't break the page
        Rails.logger.error "Ahoy tracking error: #{e.message}"
      end
    end
  end

  def should_track_page?
    # Only track HTML responses and exclude admin pages and specific URLs
    return false unless response.content_type&.start_with?("text/html")
    return false if request.path.start_with?("/admin")
    return false if request.path.start_with?("/en/admin")
    return false if request.path.start_with?("/search_logs")
    
    true
  end

  private

  def find_or_create_visit
    # Get or create a visit for this session
    # Only create visits for non-admin pages
    return nil unless should_track_page?
    
    visit_token = session[:ahoy_visit_token]
    
    if visit_token
      visit = Ahoy::Visit.find_by(visit_token: visit_token)
    end
    
    unless visit
      visit = Ahoy::Visit.create!(
        visit_token: SecureRandom.uuid,
        visitor_token: session[:ahoy_visitor_token] ||= SecureRandom.uuid,
        started_at: Time.current,
        ip: request.remote_ip,
        user_agent: request.user_agent,
        referrer: request.referrer,
        landing_page: request.url,
        country: request.headers['CF-IPCountry'] || 'Unknown',
        region: request.headers['CF-IPRegion'] || 'Unknown',
        city: request.headers['CF-IPCity'] || 'Unknown'
      )
      session[:ahoy_visit_token] = visit.visit_token
    end
    
    visit
  end
end
