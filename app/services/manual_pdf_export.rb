# frozen_string_literal: true

# Renders a board manual to PDF via Grover (Chromium/Puppeteer).
class ManualPdfExport
  CACHE_NAMESPACE = "manual_pdf_v2"

  def self.call(board_id:, html:, display_url:, cache_key: nil)
    new(board_id: board_id, html: html, display_url: display_url, cache_key: cache_key).call
  end

  def initialize(board_id:, html:, display_url:, cache_key: nil)
    @board_id = board_id.to_s
    @html = html
    @display_url = display_url
    @cache_key = cache_key
  end

  def call
    if @cache_key
      cached = Rails.cache.read(cache_entry_key)
      return cached if cached
    end

    pdf = ::Grover.new(
      @html,
      display_url: @display_url,
      footer_template: footer_template,
      display_header_footer: true,
      header_template: "<div></div>"
    ).to_pdf

    Rails.cache.write(cache_entry_key, pdf, expires_in: 7.days) if @cache_key
    pdf
  end

  def filename
    "#{@board_id}-manual.pdf"
  end

  private

  def cache_entry_key
    [CACHE_NAMESPACE, @board_id, @cache_key]
  end

  def footer_template
    <<~HTML
      <div style="width:100%;font-size:9px;padding:0 12mm;color:#666;font-family:ui-monospace,monospace;display:flex;justify-content:space-between;">
        <span>#{ERB::Util.html_escape(@board_id)} manual · baldrickboard.com</span>
        <span><span class="pageNumber"></span> / <span class="totalPages"></span></span>
      </div>
    HTML
  end
end
