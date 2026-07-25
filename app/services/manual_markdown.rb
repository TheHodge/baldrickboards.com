require "kramdown"

class ManualMarkdown
  CALLOUT_TYPES = %w[warn note tip info].freeze

  CALLOUT_ICONS = {
    "warn" => '<path d="M12 9v4m0 4h.01M10.3 3.6 2.6 17a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/>',
    "note" => '<circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v4h1"/>',
    "tip" => '<circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v4h1"/>',
    "info" => '<path d="M12 16v-4m0-4h.01M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0z"/>'
  }.freeze

  BLOCK_PATTERN = /
    ^:::\s+(figure|\w+)(?:[ \t]+([^\n]+))?\n
    (.*?)
    \n:::\s*(?:\n|$)
  /mx

  def self.render(text, view_context: nil)
    new(view_context: view_context).render(text)
  end

  def self.parse_front_matter(text)
    text = text.to_s
    return { metadata: {}, body: text } unless text.start_with?("---\n")

    parts = text.split("\n---\n", 2)
    return { metadata: {}, body: text } unless parts.length == 2

    metadata = YAML.safe_load(parts.first.delete_prefix("---\n"), permitted_classes: [], permitted_symbols: [], aliases: false) || {}
    { metadata: metadata.stringify_keys, body: parts.last.lstrip }
  rescue Psych::SyntaxError
    { metadata: {}, body: text }
  end

  def self.toc_entries(text)
    text.to_s.each_line.filter_map do |line|
      next unless line.match?(/\A###\s+/)

      if line =~ /\A###\s+(.+?)(?:\s+\{#([^}]+)\})?\s*\z/
        title = Regexp.last_match(1).strip
        id = Regexp.last_match(2).presence || slugify(title)
        { id: id, title: title }
      end
    end
  end

  def self.slugify(text)
    text.to_s.parameterize
  end

  def initialize(view_context: nil)
    @view = view_context
    @blocks = {}
    @block_index = 0
  end

  def render(text)
    parsed = self.class.parse_front_matter(text.to_s)
    body = parsed[:body]
    body = extract_blocks(body)
    html = render_markdown(body)
    html = restore_blocks(html)
    html = wrap_lead_paragraph(html)
    html = enhance_links(html)
    html = render_images(html)
    html = wrap_standalone_images(html)
    html.html_safe
  end

  private

  def extract_blocks(text)
    text.gsub(BLOCK_PATTERN) do
      kind = Regexp.last_match(1).downcase
      title = Regexp.last_match(2)
      body = Regexp.last_match(3).strip
      placeholder = block_placeholder(kind == "figure" ? figure_html(body) : callout_html(kind, title, body))
      "\n\n#{placeholder}\n\n"
    end
  end

  def block_placeholder(html)
    key = "MANUALBLOCK#{@block_index}"
    @block_index += 1
    @blocks[key] = html
    "<!--#{key}-->"
  end

  def restore_blocks(html)
    @blocks.each do |key, block_html|
      html = html.gsub("<!--#{key}-->", block_html)
      html = html.gsub("<p><!--#{key}--></p>", block_html)
    end
    html
  end

  def callout_html(type, title, body)
    type = "note" unless CALLOUT_TYPES.include?(type)
    icon = CALLOUT_ICONS.fetch(type)
    label = title.present? ? "<b>#{ERB::Util.html_escape(title)}</b> " : ""
    body_html = render_markdown(body)

    <<~HTML
      <div class="callout #{type}">
        <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">#{icon}</svg>
        <div>#{label}#{body_html}</div>
      </div>
    HTML
  end

  def figure_html(body)
    image_match = body.match(/\A!\[([^\]]*)\]\(([^)]+)\)\n?/m)
    remainder = body
    image_html = ""

    if image_match
      alt = image_match[1]
      src = image_match[2]
      image_html = image_markup(src, alt: alt)
      remainder = body.sub(image_match[0], "").strip
    end

    caption_html = remainder.present? ? render_markdown(remainder) : ""

    <<~HTML
      <div class="figure">
        <div class="fimg">#{image_html}</div>
        #{caption_html}
      </div>
    HTML
  end

  def render_markdown(text)
    ::Kramdown::Document.new(
      text,
      hard_wrap: false,
      auto_ids: true,
      parse_block_html: true,
      parse_span_html: true
    ).to_html
  end

  def wrap_lead_paragraph(html)
    html.sub(/\A<p>/, '<p class="lead">')
  end

  def enhance_links(html)
    html.gsub(/<a href="(https?:\/\/[^"]+)">([^<]+)<\/a>/) do
      url = Regexp.last_match(1)
      label = Regexp.last_match(2)
      %(<a href="#{url}" class="lnk" target="_blank" rel="noopener noreferrer">#{label}</a>)
    end
  end

  def render_images(html)
    html.gsub(/<img([^>]*?)src="([^"]+)"([^>]*?)>/m) do
      attrs = Regexp.last_match(1) + Regexp.last_match(3)
      src = Regexp.last_match(2)
      alt = attrs[/alt="([^"]*)"/, 1] || ""
      image_markup(src, alt: alt)
    end
  end

  def wrap_standalone_images(html)
    html.gsub(/<p>\s*(<img[^>]+class="doc-img"[^>]*>)\s*<\/p>/m, '<div class="doc-photo">\1</div>')
  end

  def image_markup(src, alt:)
    if @view
      @view.image_tag(src, alt: alt, class: "doc-img")
    else
      %(<img src="#{ERB::Util.html_escape(src)}" alt="#{ERB::Util.html_escape(alt)}" class="doc-img">)
    end
  end
end
