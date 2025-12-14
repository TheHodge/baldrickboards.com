class CaseSolution < ApplicationRecord
  # Associations
  belongs_to :case
  belongs_to :solution

  # Validations
  validates :match_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :case_id, uniqueness: { scope: :solution_id }

  # Scopes
  scope :by_score, -> { order(match_score: :desc) }
  scope :presented, -> { where.not(presented_at: nil) }
end
