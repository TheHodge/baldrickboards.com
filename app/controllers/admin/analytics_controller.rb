class Admin::AnalyticsController < Admin::BaseController
  def index
    # Get date range (default to last 30 days)
    @date_range = params[:date_range] || '30'
    @start_date = @date_range.to_i.days.ago.beginning_of_day
    @end_date = Time.current.end_of_day

    # Get basic stats
    @total_visits = Ahoy::Visit.where(started_at: @start_date..@end_date).count
    @total_events = Ahoy::Event.where(time: @start_date..@end_date).count
    @unique_visitors = Ahoy::Visit.where(started_at: @start_date..@end_date).distinct.count(:visitor_token)

    # Get top pages
    @top_pages = Ahoy::Event
      .where(time: @start_date..@end_date)
      .where(name: 'Page view')
      .where("properties->>'url' IS NOT NULL")
      .group("properties->>'url'")
      .count
      .sort_by { |_, count| -count }
      .first(10)

    # Get visits by day for chart
    @visits_by_day = Ahoy::Visit
      .where(started_at: @start_date..@end_date)
      .group("DATE(started_at)")
      .count
      .sort_by { |date, _| date }

    # Get top referrers
    @top_referrers = Ahoy::Visit
      .where(started_at: @start_date..@end_date)
      .where.not(referrer: [nil, ''])
      .group(:referrer)
      .count
      .sort_by { |_, count| -count }
      .first(10)

    # Get user agents (browsers)
    @top_browsers = Ahoy::Visit
      .where(started_at: @start_date..@end_date)
      .where.not(user_agent: [nil, ''])
      .group(:user_agent)
      .count
      .sort_by { |_, count| -count }
      .first(10)

    # Get countries
    @top_countries = Ahoy::Visit
      .where(started_at: @start_date..@end_date)
      .where.not(country: [nil, ''])
      .group(:country)
      .count
      .sort_by { |_, count| -count }
      .first(10)
  end
end
