class FeedbackMailer < ApplicationMailer
  def new_feedback(feedback)
    @feedback = feedback
    
    mail(
      to: 'dom@ilightthat.com', # Update with your admin email
      subject: "New #{feedback.feedback_type.capitalize} Submission - #{feedback.name}"
    )
  end
end
