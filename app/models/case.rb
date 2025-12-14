class Case < ApplicationRecord
  # Associations
  belongs_to :user, optional: true # Future login integration
  belongs_to :solved_by_solution, class_name: 'Solution', foreign_key: 'solved_by_solution_id', optional: true
  has_many :case_solutions, dependent: :destroy
  has_many :solutions, through: :case_solutions
  has_many_attached :media

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :problem_description, presence: true, length: { minimum: 10 }
  validates :status, inclusion: { in: %w[open solved closed] }
  validates :access_token, presence: true, uniqueness: true
  validates :access_code, presence: true, length: { is: 6 }
  validates :case_number, presence: true, uniqueness: true
  validates :knowledge_level, inclusion: { in: 1..10 }, allow_nil: true
  validate :validate_media_attachments

  def validate_media_attachments
    return unless media.attached?

    # Check file count
    if media.count > 10
      errors.add(:media, "cannot have more than 10 files")
      return
    end

    # Check individual file sizes (100MB = 100 * 1024 * 1024 bytes)
    max_size = 100.megabytes
    media.each do |file|
      if file.byte_size > max_size
        errors.add(:media, "#{file.filename} is too large (maximum 100MB per file)")
      end
    end
  end

  # Scopes
  scope :open, -> { where(status: 'open') }
  scope :solved, -> { where(status: 'solved') }
  scope :closed, -> { where(status: 'closed') }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_user, ->(user) { where(user_id: user.id) } # For future login
  scope :by_email, ->(email) { where(email: email) } # For access code fallback

  # Callbacks
  before_validation :generate_access_token, on: :create
  before_validation :generate_access_code, on: :create
  before_validation :assign_case_number, on: :create

  # Instance methods
  def open?
    status == 'open'
  end

  def solved?
    status == 'solved'
  end

  def closed?
    status == 'closed'
  end

  def mark_as_solved!(solution_id = nil)
    update!(status: 'solved', solved_by_solution_id: solution_id)
  end

  def mark_as_closed!
    update!(status: 'closed')
  end

  # Check if case belongs to a user (for future login integration)
  def belongs_to_user?(user)
    return false unless user
    user_id.present? && user_id == user.id
  end

  # Check if case belongs to email (for access code fallback)
  def belongs_to_email?(email)
    self.email.downcase == email.downcase
  end

  # Solution matching algorithm
  def match_solutions
    return [] unless problem_description.present?

    # Get all active solutions
    active_solutions = Solution.where(active: true)

    matches = []
    keywords = extract_keywords

    active_solutions.each do |solution|
      score = calculate_match_score(solution, keywords)
      if score > 0
        matches << { solution: solution, score: score }
      end
    end

    # Sort by score and take top 3
    top_matches = matches.sort_by { |m| -m[:score] }.first(3)

    # Store matches in join table
    top_matches.each do |match|
      case_solution = case_solutions.find_or_initialize_by(solution: match[:solution])
      case_solution.match_score = match[:score]
      case_solution.presented_at ||= Time.current
      case_solution.save!

      # Increment match count on solution
      match[:solution].increment!(:match_count)
    end

    top_matches.map { |m| m[:solution] }
  end

  private

  def generate_access_token
    self.access_token ||= SecureRandom.urlsafe_base64(32)
  end

  def generate_access_code
    self.access_code ||= format('%06d', rand(1000000))
  end

  def assign_case_number
    return if case_number.present?
    # Generate a random non-sequential case number (6 digits)
    loop do
      candidate = rand(100000..999999)
      unless Case.exists?(case_number: candidate)
        self.case_number = candidate
        break
      end
    end
  end

  def extract_keywords
    text = [problem_description, tried_solutions].compact.join(' ').downcase
    # Remove common stop words and extract meaningful words
    stop_words = %w[the a an and or but in on at to for of with by from as is was are were been be have has had do does did will would should could may might must can this that these those i you he she it we they]
    words = text.scan(/\b[a-z]{3,}\b/) # Words with 3+ letters
    words.reject { |w| stop_words.include?(w) }.uniq
  end

  def calculate_match_score(solution, keywords)
    score = 0

    # Check keyword matches
    solution.problem_keywords.each do |keyword|
      if keywords.include?(keyword.downcase)
        score += 10
      end
      # Partial matches
      keywords.each do |kw|
        if kw.include?(keyword.downcase) || keyword.downcase.include?(kw)
          score += 5
        end
      end
    end

    # Board type matches
    if affected_boards.present? && solution.board_types.present?
      common_boards = affected_boards & solution.board_types
      score += common_boards.length * 15
    end

    score
  end
end
