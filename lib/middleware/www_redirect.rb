class WwwRedirect
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    
    # Only redirect in production and if the request is not already to www
    if Rails.env.production? && request.host == 'baldrickboard.com'
      # Build the redirect URL with the same path and query parameters
      redirect_url = "https://www.baldrickboard.com#{request.fullpath}"
      
      return [
        301,
        {
          'Location' => redirect_url,
          'Content-Type' => 'text/html',
          'Cache-Control' => 'no-cache'
        },
        ['Redirecting to www.baldrickboard.com...']
      ]
    end
    
    @app.call(env)
  end
end
