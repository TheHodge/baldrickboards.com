class NewsletterSubscriber < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { case_sensitive: false }

  before_create :set_subscribed_at

  scope :recent, -> { order(subscribed_at: :desc) }

  private

  def set_subscribed_at
    self.subscribed_at = Time.current
  end
end
