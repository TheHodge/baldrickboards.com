class PagesController < ApplicationController
  def home
    @home_page = true
  end

  def where_to_buy
    @baldrickboard_page = true
  end
  
  def search_test
  end
  
  def beginners_guide
  end

  def everyones_business
    render layout: "application"
  end

  def year_2026
    @newsletter_heading = 'Join our mailing list'
    @newsletter_description = 'Find out when we make our announcements.'
  end
end
