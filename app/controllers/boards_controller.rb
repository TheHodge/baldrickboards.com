class BoardsController < ApplicationController
  before_action :set_baldrickboard_page
  before_action :set_board_name, only: %i[manual_pdf manual_markdown]
  before_action :ensure_manual_board!, only: %i[manual_pdf manual_markdown]

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

  MANUAL_REDIRECTS = {
    'tech-specs' => 'tech-specs',
    'getting-started' => 'getting-started',
    'web-interface' => 'web-interface'
  }.freeze

  # Generic method to handle all board pages
  def show
    @board_name = params[:board]
    @page = params[:page]
    
    # Set the view template based on the URL
    if @page.present?
      if (anchor = MANUAL_REDIRECTS[@page])
        redirect_to "#{board_page_path(@board_name, 'manual')}##{anchor}", allow_other_host: false
        return
      end

      # Sub-page like /boards/baldrick8/getting-started
      # Convert URL format to template format: getting-started -> getting_started
      template_name = @page.gsub('-', '_')
      render "boards/#{@board_name}/#{template_name}"
    else
      # Main board page like /boards/baldrick8
      render "boards/#{@board_name}/overview"
    end
  end

  def manual_pdf
    html = render_to_string(
      template: "boards/shared/manual_pdf",
      layout: "pdf",
      formats: [:html],
      locals: { board_id: @board_name }
    )

    exporter = ManualPdfExport.new(
      board_id: @board_name,
      html: html,
      display_url: request.base_url,
      cache_key: manual_content_cache_key(@board_name)
    )

    send_data exporter.call,
              filename: exporter.filename,
              type: "application/pdf",
              disposition: "attachment"
  rescue ::Grover::Error => e
    Rails.logger.error("[ManualPdf] #{@board_name}: #{e.class}: #{e.message}")
    redirect_to board_page_path(@board_name, "manual"),
                alert: "PDF generation is temporarily unavailable. Try the Markdown download, or try again shortly."
  end


  def manual_markdown
    exporter = ManualMarkdownExport.new(@board_name)

    send_data exporter.call,
              filename: exporter.filename,
              type: "text/markdown; charset=utf-8",
              disposition: "attachment"
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

  private

  def set_baldrickboard_page
    @baldrickboard_page = true
  end

  def set_board_name
    @board_name = params[:board].to_s
  end

  def ensure_manual_board!
    return if helpers.board_data.key?(@board_name) && helpers.board_manual_entries(@board_name).present?

    head :not_found
  end

  def manual_content_cache_key(board_id)
    entries = helpers.board_manual_entries(board_id)
    fingerprint = entries.map { |entry| "#{entry[:path].basename}:#{entry[:path].mtime.to_i}" }.join("|")
    specs = helpers.board_tech_specs_rows(board_id).inspect
    Digest::SHA256.hexdigest("#{board_id}:#{I18n.locale}:#{fingerprint}:#{specs}")
  end
end

