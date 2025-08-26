class BoardsController < ApplicationController
  def index
  end

  # Board category actions
  def pixel_controllers
  end

  def relay_controllers
  end

  def interactive_controllers
  end

  def portable_controllers
  end

  def power_distribution
  end

  def dmx_controllers
  end

  # Generic method to handle all board pages
  def show
    @board_name = params[:board]
    @page = params[:page]
    
    # Set the view template based on the URL
    if @page.present?
      # Sub-page like /boards/baldrick8/getting-started
      # Convert URL format to template format: getting-started -> getting_started
      template_name = @page.gsub('-', '_')
      render "boards/#{@board_name}/#{template_name}"
    else
      # Main board page like /boards/baldrick8
      render "boards/#{@board_name}/overview"
    end
  end

  # Catch-all method for any board action (fallback)
  def method_missing(method_name, *args, &block)
    # Check if this is a board page request
    if method_name.to_s.match?(/^baldrick\w+(_\w+)?$/)
      @board_name = method_name.to_s.split('_').first
      @page = method_name.to_s.split('_')[1..-1]&.join('_')
      
      if @page.present?
        render "boards/#{@board_name}/#{@page}"
      else
        render "boards/#{@board_name}/overview"
      end
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.match?(/^baldrick\w+(_\w+)?$/) || super
  end
end
