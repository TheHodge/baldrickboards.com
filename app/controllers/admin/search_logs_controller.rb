class Admin::SearchLogsController < Admin::BaseController
  def index
    @search_logs = SearchLog.order(created_at: :desc)
                           .limit(100)
    
    # Get some basic statistics
    @total_searches = SearchLog.searches.count
    @total_clicks = SearchLog.clicks.count
    @recent_searches = SearchLog.recent(7).searches.count
    @recent_clicks = SearchLog.recent(7).clicks.count
    
    # Top search queries
    @top_queries = SearchLog.searches
                           .group(:query)
                           .order(Arel.sql('count(*) DESC'))
                           .limit(10)
                           .count
    
    # Top clicked results
    @top_clicks = SearchLog.clicks
                          .group(:result_url, :result_title)
                          .order(Arel.sql('count(*) DESC'))
                          .limit(10)
                          .count
  end
end
