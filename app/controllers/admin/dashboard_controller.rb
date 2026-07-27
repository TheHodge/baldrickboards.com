class Admin::DashboardController < Admin::BaseController
  def index
    # Dashboard statistics
    @total_newsletter_subscribers = NewsletterSubscriber.count
    @total_feedbacks = Feedback.count
    @new_feedbacks = Feedback.new_feedback.count
    @total_searches = SearchLog.count
    @recent_searches = SearchLog.recent(7).count
    
    # Triage statistics
    @total_cases = Case.count
    @open_cases = Case.open.count
    @solved_cases = Case.solved.count
    @new_cases_today = Case.where(created_at: Date.current.all_day).count
    @total_solutions = Solution.count
    @active_solutions = Solution.active.count
    
    # Analytics statistics
    @total_visits = Ahoy::Visit.count
    @recent_visits = Ahoy::Visit.where(started_at: 7.days.ago..Time.current).count
    @total_events = Ahoy::Event.count
    @recent_events = Ahoy::Event.where(time: 7.days.ago..Time.current).count
    
    # 404 Error statistics
    @total_404_errors = ErrorLog.sum(:count)
    @unique_404_errors = ErrorLog.count
    @recent_404_errors = ErrorLog.where(last_seen: 7.days.ago..Time.current).sum(:count)

    @baldrick_buddy_releases_enabled = BaldrickBuddy::Config.enabled?
    @baldrick_buddy_release = BaldrickBuddy::ReleaseFetcher.fetch if @baldrick_buddy_releases_enabled
  end
end
