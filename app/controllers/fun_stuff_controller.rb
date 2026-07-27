class FunStuffController < ApplicationController
  before_action :set_baldrickboard_page

  def index
  end

  def release_notes
  end

  def stls_and_mounts
  end

  def board_dimensions
  end

  def faq
  end

  def problem_solver
  end

  def panic_mode
  end

  def testimonials
  end

  def customer_showcase
  end

  def baldrick_buddy
    @release = BaldrickBuddy::ReleaseFetcher.fetch
  end

  private

  def set_baldrickboard_page
    @baldrickboard_page = true
  end
end
