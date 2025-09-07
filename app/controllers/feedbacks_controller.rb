class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    
    if @feedback.save
      # Send notification email to admin
      FeedbackMailer.new_feedback(@feedback).deliver_now
      
      redirect_to feedbacks_success_path, notice: 'Thank you for your feedback! We\'ll review it and may feature it on our site.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def success
    # Success page - no additional logic needed
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback_type, :content, :image)
  end
end
