class TodoistWebhookEvent < ApplicationRecord
  validates :event_key, presence: true, uniqueness: true
  validates :processed_at, presence: true
end
