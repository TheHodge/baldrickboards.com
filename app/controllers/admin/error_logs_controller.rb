class Admin::ErrorLogsController < Admin::BaseController
  def index
    @error_logs = ErrorLog.most_frequent
    
    # Get summary stats
    @total_404s = ErrorLog.sum(:count)
    @unique_404s = ErrorLog.count
    @top_referrers = ErrorLog.group(:referrer).sum(:count).sort_by { |_, count| -count }.first(10)
    @top_browsers = ErrorLog.group(:user_agent).sum(:count).sort_by { |_, count| -count }.first(10)
    
    # Filter by date range if provided
    if params[:date_range].present?
      days = params[:date_range].to_i
      @error_logs = @error_logs.where('last_seen >= ?', days.days.ago)
    end
  end
  
  def show
    @error_log = ErrorLog.find(params[:id])
  end
  
  def destroy
    @error_log = ErrorLog.find(params[:id])
    @error_log.destroy
    redirect_to admin_error_logs_path, notice: 'Error log deleted successfully.'
  end
  
  def clear_all
    ErrorLog.delete_all
    redirect_to admin_error_logs_path, notice: 'All error logs cleared successfully.'
  end
end
