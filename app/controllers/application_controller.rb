class ApplicationController < ActionController::Base

  # Ahoy analytics tracking will be implemented directly

  # Set locale from URL parameter (skip for Active Storage and API routes)
  before_action :set_locale, unless: :skip_locale?
  
  # Record page views for analytics
  after_action :record_page_view

  # Custom 404 handling
  def not_found
    # Track 404 errors for admin analysis
    ErrorLog.track_404(
      request.url,
      referrer: request.referrer,
      user_agent: request.user_agent,
      ip: real_client_ip
    )
    
    render 'errors/not_found', status: :not_found, layout: 'application'
  end

  private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale]
    else
      # Skip locale redirect for API routes (search logging, etc.)
      if api_route?
        I18n.locale = I18n.default_locale
      else
        # Redirect to default locale to avoid duplicate content
        redirect_to url_for(locale: I18n.default_locale, only_path: false), status: :moved_permanently
      end
    end
  end

  def skip_locale?
    api_route? || active_storage_route? || request.path == "/qr-code-sticker"
  end

  def api_route?
    # Routes that should not be redirected for locale
    api_paths = %w[
      /search_logs/log_search
      /search_logs/log_click
      /sitemap.xml
    ]
    
    # Also check for common API patterns
    api_patterns = [
      /^\/search_logs\//,  # All search logging routes
      /^\/sitemap\.xml$/,  # Sitemap
    ]
    
    # Check exact path matches first
    api_paths.include?(request.path) ||
    # Then check pattern matches
    api_patterns.any? { |pattern| request.path.match?(pattern) }
  end

  def active_storage_route?
    request.path.start_with?('/rails/active_storage')
  end

  def default_url_options(options = {})
    # Don't add locale to Active Storage URLs
    if request&.path&.start_with?('/rails/active_storage')
      {}
    else
      { locale: I18n.locale }
    end
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

  def real_client_ip
    # Get the real client IP from Cloudflare headers
    # CF-Connecting-IP is the most reliable header from Cloudflare
    request.headers['CF-Connecting-IP'] || 
    request.headers['X-Forwarded-For']&.split(',')&.first&.strip ||
    request.remote_ip
  end

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
        ip: real_client_ip,
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
