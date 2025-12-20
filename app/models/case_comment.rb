class CaseComment < ApplicationRecord
  belongs_to :case

  validates :content, presence: true, length: { minimum: 1 }
  validates :admin_name, presence: true
end
