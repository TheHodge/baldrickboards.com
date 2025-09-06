class Contact < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { minimum: 5, maximum: 200 }
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :status, inclusion: { in: %w[new in_progress resolved closed] }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :unread, -> { where(status: 'new') }

  def mark_as_read!
    update!(status: 'in_progress')
  end

  def mark_as_resolved!
    update!(status: 'resolved')
  end

  def mark_email_sent!
    update!(email_sent: true, email_sent_at: Time.current)
  end

  def full_name
    name.strip
  end

  def email_domain
    email.split('@').last
  end
end
