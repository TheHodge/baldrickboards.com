class NewsletterSubscribersController < ApplicationController
  def create
    @subscriber = NewsletterSubscriber.new(subscriber_params)

    if @subscriber.save
      flash[:notice] = "Thank you for subscribing! You'll receive the latest Baldrick updates."
    elsif @subscriber.errors.added?(:email, :taken)
      flash[:alert] = 'That email is already subscribed.'
    else
      flash[:alert] = 'Please enter a valid email address.'
    end

    redirect_to newsletter_return_url
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

  def newsletter_return_url
    referer = request.referer.presence || root_url
    uri = URI.parse(referer)
    uri.fragment = 'newsletter'
    uri.to_s
  rescue URI::InvalidURIError
    root_url(anchor: 'newsletter')
  end
end