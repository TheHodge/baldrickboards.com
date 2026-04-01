class PagesController < ApplicationController
  def home
  end

  def where_to_buy
  end
  
  def search_test
  end
  
  def beginners_guide
  end

  def everyones_business
    render layout: "application"
  end

  def year_2026
    @hide_newsletter_footer = true
  end
end
