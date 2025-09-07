class SearchLog < ApplicationRecord
  validates :query, presence: true, length: { minimum: 2 }
  validates :result_url, presence: true, if: :clicked?
  
  scope :searches, -> { where(clicked: false) }
  scope :clicks, -> { where(clicked: true) }
  scope :recent, ->(days = 30) { where(created_at: days.days.ago..) }
  scope :by_query, ->(query) { where(query: query) }
  
  def self.log_search(query, ip_address: nil, user_agent: nil)
    return if query.blank? || query.length < 2
    
    create!(
      query: query.strip,
      clicked: false,
      ip_address: ip_address,
      user_agent: user_agent
    )
  end
  
  def self.log_click(query, result_url, result_title, ip_address: nil, user_agent: nil)
    return if query.blank? || query.length < 2 || result_url.blank?
    
    create!(
      query: query.strip,
      result_url: result_url,
      result_title: result_title,
      clicked: true,
      ip_address: ip_address,
      user_agent: user_agent
    )
  end
end
