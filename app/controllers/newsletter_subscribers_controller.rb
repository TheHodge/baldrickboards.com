class NewsletterSubscribersController < ApplicationController
  def create
    @subscriber = NewsletterSubscriber.new(subscriber_params)

    if @subscriber.save
      flash[:notice] = 'Thank you for subscribing! You\'ll receive the latest Baldrick updates.'
    else
      flash[:alert] = 'Please enter a valid email address.'
    end

    # Redirect back to the previous page
    redirect_back(fallback_location: root_path)
  end

  def unsubscribe
    @subscriber = NewsletterSubscriber.find_by(email: params[:email])
    
    if @subscriber
      @subscriber.destroy
      flash[:notice] = 'You have been successfully unsubscribed from our newsletter.'
    else
      flash[:alert] = 'Email address not found in our newsletter list.'
    end
  end

  private

  def subscriber_params
    params.require(:newsletter_subscriber).permit(:email)
  end
end