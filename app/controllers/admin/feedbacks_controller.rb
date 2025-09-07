class Admin::FeedbacksController < Admin::BaseController
  before_action :set_feedback, only: [:show, :destroy, :mark_processed]

  def index
    @feedbacks = Feedback.includes(:image_attachment)
                        .order(created_at: :desc)
    
    # Filter by type if specified
    if params[:type].present?
      @feedbacks = @feedbacks.where(feedback_type: params[:type])
    end
    
    # Filter by status if specified
    if params[:status].present?
      @feedbacks = @feedbacks.where(status: params[:status])
    end
    
    # Statistics
    @total_feedbacks = Feedback.count
    @new_feedbacks = Feedback.new_feedback.count
    @processed_feedbacks = Feedback.processed.count
    @testimonials = Feedback.testimonials.count
    @showcases = Feedback.showcases.count
  end

  def show
    # Show individual feedback details
  end

  def destroy
    @feedback.destroy
    redirect_to admin_feedbacks_path, notice: 'Feedback deleted successfully.'
  end

  def mark_processed
    @feedback.update(processed: true, processed_at: Time.current, status: 'processed')
    redirect_to admin_feedbacks_path, notice: 'Feedback marked as processed.'
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end
end
