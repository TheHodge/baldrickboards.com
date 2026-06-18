class FaqController < ApplicationController
  before_action :set_baldrickboard_page

  def index
  end

  private

  def set_baldrickboard_page
    @baldrickboard_page = true
  end
end
