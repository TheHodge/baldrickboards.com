class Admin::DashboardController < Admin::BaseController
  def index
    # Dashboard statistics
    @total_newsletter_subscribers = NewsletterSubscriber.count
    @total_feedbacks = Feedback.count
    @new_feedbacks = Feedback.new_feedback.count
    @total_searches = SearchLog.count
    @recent_searches = SearchLog.recent(7).count
  end
end
