class Admin::NewsletterSubscribersController < Admin::BaseController
  def index
    @subscribers = NewsletterSubscriber.recent
    @total_count = @subscribers.count
  end

  def export_csv
    subscribers = NewsletterSubscriber.recent
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Email', 'Subscribed At']
      subscribers.each do |subscriber|
        csv << [
          subscriber.email,
          subscriber.subscribed_at&.strftime('%Y-%m-%d %H:%M:%S UTC')
        ]
      end
    end

    respond_to do |format|
      format.csv do
        send_data csv_data, 
                  filename: "newsletter_subscribers_#{Date.current.strftime('%Y%m%d')}.csv",
                  type: 'text/csv'
      end
    end
  end

  def destroy
    @subscriber = NewsletterSubscriber.find(params[:id])
    @subscriber.destroy
    redirect_to admin_newsletter_subscribers_path, notice: 'Subscriber removed successfully.'
  end
end
