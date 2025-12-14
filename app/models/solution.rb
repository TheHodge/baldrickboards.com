class Solution < ApplicationRecord
  # Associations
  has_many :case_solutions, dependent: :destroy
  has_many :cases, through: :case_solutions
  has_many :solved_cases, class_name: 'Case', foreign_key: 'solved_by_solution_id'

  # Validations
  validates :problem_title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :solution_text, presence: true, length: { minimum: 10 }
  validates :problem_keywords, presence: true
  validates :match_count, numericality: { greater_than_or_equal_to: 0 }
  validates :success_count, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_success_rate, -> { order(success_count: :desc) }
  scope :by_match_count, -> { order(match_count: :desc) }

  # Instance methods
  def active?
    active
  end

  def success_rate
    return 0.0 if match_count.zero?
    (success_count.to_f / match_count.to_f * 100).round(2)
  end

  def increment_success!
    increment!(:success_count)
  end
end
