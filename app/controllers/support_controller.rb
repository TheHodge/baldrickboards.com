class SupportController < ApplicationController
  before_action :set_baldrickboard_page

  def index
  end

  def software
  end

  def asking_for_help
  end

  private

  def set_baldrickboard_page
    @baldrickboard_page = true
  end
end
