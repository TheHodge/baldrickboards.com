class Ahoy::Event < ApplicationRecord
  self.table_name = "ahoy_events"

  belongs_to :visit, class_name: "Ahoy::Visit"
  belongs_to :user, optional: true
end
