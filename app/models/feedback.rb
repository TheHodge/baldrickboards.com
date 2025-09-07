class Feedback < ApplicationRecord
  has_one_attached :image
  
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :feedback_type, presence: true, inclusion: { in: %w[testimonial showcase] }
  validates :content, presence: true, length: { minimum: 10 }
  
  scope :testimonials, -> { where(feedback_type: 'testimonial') }
  scope :showcases, -> { where(feedback_type: 'showcase') }
  scope :new_feedback, -> { where(status: 'new') }
  scope :processed, -> { where(processed: true) }
  scope :recent, ->(days = 30) { where(created_at: days.days.ago..) }
  
  def testimonial?
    feedback_type == 'testimonial'
  end
  
  def showcase?
    feedback_type == 'showcase'
  end
  
  def has_image?
    image.attached?
  end
end
