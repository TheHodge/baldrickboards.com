class SearchLogsController < ApplicationController
  # Skip CSRF protection for these API endpoints
  skip_before_action :verify_authenticity_token, only: [:log_search, :log_click]
  
  def log_search
    query = params[:query]&.strip
    
    # Only log searches with reasonable length (2+ characters)
    if query.present? && query.length >= 2
      SearchLog.log_search(
        query,
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
    end
    
    head :ok
  end

  def log_click
    query = params[:query]&.strip
    result_url = params[:result_url]
    result_title = params[:result_title]
    
    # Only log clicks with reasonable query length and valid result
    if query.present? && query.length >= 2 && result_url.present?
      SearchLog.log_click(
        query,
        result_url,
        result_title,
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
    end
    
    head :ok
  end
end
