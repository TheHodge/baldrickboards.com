class ErrorLog < ApplicationRecord
  validates :url, presence: true
  
  scope :recent, -> { order(last_seen: :desc) }
  scope :most_frequent, -> { order(count: :desc) }
  
  def self.track_404(url, referrer: nil, user_agent: nil, ip: nil)
    # Find existing error log for this URL
    error_log = find_by(url: url)
    
    if error_log
      # Update existing record
      error_log.increment!(:count)
      error_log.update!(
        last_seen: Time.current,
        referrer: referrer,
        user_agent: user_agent,
        ip: ip
      )
    else
      # Create new record
      create!(
        url: url,
        referrer: referrer,
        user_agent: user_agent,
        ip: ip,
        count: 1,
        last_seen: Time.current
      )
    end
  end
  
  def domain
    return 'Direct / Unknown' if referrer.blank?
    
    begin
      URI.parse(referrer).host
    rescue URI::InvalidURIError
      'Invalid URL'
    end
  end
  
  def browser
    return 'Unknown' if user_agent.blank?
    
    # Simple browser detection
    case user_agent
    when /Chrome/
      'Chrome'
    when /Firefox/
      'Firefox'
    when /Safari/
      'Safari'
    when /Edge/
      'Edge'
    when /Opera/
      'Opera'
    else
      'Other'
    end
  end
end
