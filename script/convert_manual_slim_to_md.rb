#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "erb"

class ManualSlimConverter
  HEADING_PREFIX = { "h1" => "#", "h2" => "##", "h3" => "###", "h4" => "####", "h5" => "#####", "h6" => "######" }.freeze

  def self.convert_all(root)
    Dir.glob(File.join(root, "app/views/boards/*/manual/*.html.slim")).sort.each do |path|
      board = path[%r{boards/([^/]+)/manual/}, 1]
      section = File.basename(path, ".html.slim")
      out_path = File.join(root, "content/manuals/#{board}/#{section}.md")
      slim = File.read(path)
      md = new(board: board).convert(slim)
      FileUtils.mkdir_p(File.dirname(out_path))
      File.write(out_path, md)
      puts "Wrote #{out_path}"
    end
  end

  def initialize(board:)
    @board = board
  end

  def convert(slim)
    slim = preprocess_ruby(slim)
    lines = slim.lines.map(&:chomp)
    @i = 0
    @parts = []

    while @i < lines.length
      line = lines[@i]
      if line.strip.empty?
        @i += 1
        next
      end

      indent = line[/\A */].length

      if line.strip.start_with?("/")
        @i += 1
        next
      end

      if (heading = parse_heading(line))
        @parts << heading
        @i += 1
        next
      end

      if line.strip.start_with?(".callout.")
        @parts << parse_callout(lines)
        next
      end

      if line.strip == ".figure" || line.strip.start_with?(".figure ")
        @parts << parse_figure(lines)
        next
      end

      if line.strip.start_with?(".manual-tabs") || line.strip.start_with?(".spec-grid")
        @parts << parse_html_block(lines, indent)
        next
      end

      if line.strip.start_with?("= image_tag")
        @parts << parse_standalone_image(line)
        @i += 1
        next
      end

      if line.strip.start_with?("p.lead") || line.strip == "p.lead"
        @parts << parse_paragraph(lines, lead: true)
        next
      end

      if line.strip.start_with?("p") && !line.strip.start_with?("path")
        @parts << parse_paragraph(lines)
        next
      end

      if line.strip.match?(/\A[uo]l(\.|\s|$)/)
        @parts << parse_list(lines, indent)
        next
      end

      if line.strip.start_with?("a.lnk") || line.strip.start_with?("= link_to")
        @parts << parse_inline_link(lines)
        next
      end

      if line.strip.start_with?(".")
        @parts << parse_html_block(lines, indent)
        next
      end

      @i += 1
    end

    cleanup(@parts.join("\n\n"))
  end

  private

  def preprocess_ruby(slim)
    slim = slim.gsub(/#\{link_to\s+"([^"]+)",\s*board_page_path\('([^']+)',\s*'([^']+)'\)[^}]*\}/) do
      label = Regexp.last_match(1)
      board = Regexp.last_match(2)
      page = Regexp.last_match(3)
      "[#{label}](/boards/#{board}/#{page})"
    end

    slim.gsub(/=\s*link_to\s+"([^"]+)",\s*board_page_path\('([^']+)',\s*'([^']+)'\)[^\n]*/) do
      label = Regexp.last_match(1)
      board = Regexp.last_match(2)
      page = Regexp.last_match(3)
      "[#{label}](/boards/#{board}/#{page})"
    end
  end

  def parse_heading(line)
    stripped = line.strip

    if stripped =~ /\A(h[1-6])(?:\.[^\s]+)*\s+id="([^"]+)"\s+(.+)\z/
      tag, id, title = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)
      return "#{HEADING_PREFIX[tag]} #{title.strip} {##{id}}"
    end

    if stripped =~ /\A(h[1-6])\s+id="([^"]+)"\s+(.+)\z/
      tag, id, title = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)
      return "#{HEADING_PREFIX[tag]} #{title.strip} {##{id}}"
    end

    if stripped =~ /\A(h[1-6])(?:\.[^\s]+)+\s+(.+)\z/
      tag, title = Regexp.last_match(1), Regexp.last_match(2)
      return "#{HEADING_PREFIX[tag]} #{title.strip}"
    end

    if stripped =~ /\A(h[1-6])\s+(.+)\z/
      tag, title = Regexp.last_match(1), Regexp.last_match(2)
      return "#{HEADING_PREFIX[tag]} #{title.strip}"
    end

    nil
  end

  def parse_callout(lines)
    start = @i
    base = lines[start][/\A */].length
    type = lines[start].strip[/\.callout\.(\w+)/, 1]
    @i += 1

    title = nil
    body_lines = []

    while @i < lines.length
      line = lines[@i]
      break if line[/\A */].length <= base && !line.strip.empty? && !line.strip.start_with?("svg", "path", "circle", "div")

      stripped = line.strip
      if stripped.start_with?("b ") || stripped == "b"
        @i += 1
        title = collect_text(lines, base + 2).strip
        next
      end

      if stripped == "div" || stripped.start_with?("svg") || stripped.start_with?("path") || stripped.start_with?("circle")
        @i += 1
        next
      end

      if stripped.start_with?("|") || stripped.start_with?("a.lnk") || stripped.start_with?("= link_to")
        body_lines << collect_text(lines, line[/\A */].length)
        next
      end

      break if line[/\A */].length <= base && !line.strip.empty?
      @i += 1
    end

    body = body_lines.join(" ").strip
    label = title.to_s.strip.empty? ? type.capitalize : title.to_s.strip
    "::: #{type} #{label}\n#{body}\n:::"
  end

  def parse_figure(lines)
    start = @i
    base = lines[start][/\A */].length
    @i += 1
    image = nil
    caption_lines = []

    while @i < lines.length
      line = lines[@i]
      break if line[/\A */].length <= base && !line.strip.empty?

      if (img = extract_image_tag(line))
        image = img
        @i += 1
        next
      end

      if line.strip.start_with?(".fimg")
        @i += 1
        next
      end

      if line.strip.start_with?("= image_tag")
        image = extract_image_tag(line)
        @i += 1
        next
      end

      if line.strip.match?(/\A[uo]l(\.|\s|$)/)
        caption_lines << parse_list(lines, line[/\A */].length)
        next
      end

      if line.strip.start_with?("p")
        caption_lines << parse_paragraph(lines)
        next
      end

      if line.strip.start_with?("h")
        break
      end

      @i += 1
    end

    parts = ["::: figure"]
    parts << "![#{image[:alt]}](#{image[:src]})" if image
    parts << caption_lines.join("\n\n") if caption_lines.any?
    parts << ":::"
    parts.join("\n")
  end

  def parse_paragraph(lines, lead: false)
    line = lines[@i]
    base = line[/\A */].length
    @i += 1
    text = collect_text(lines, base)
    text = text.strip
    return text if lead

    text
  end

  def parse_list(lines, base_indent)
    start = @i
    tag = lines[start].strip[/\A(u|o)l/, 1]
    marker = tag == "o" ? "." : "-"
    @i += 1
    items = []

    while @i < lines.length
      line = lines[@i]
      stripped = line.strip
      indent = line[/\A */].length

      break if !stripped.empty? && indent <= base_indent && !stripped.start_with?("li")

      if stripped.start_with?("li")
        @i += 1
        item = collect_list_item(lines, indent)
        items << "#{marker} #{item}"
        next
      end

      break if !stripped.empty? && indent <= base_indent
      @i += 1
    end

    items.join("\n")
  end

  def collect_list_item(lines, base)
    parts = []

    while @i < lines.length
      line = lines[@i]
      stripped = line.strip
      indent = line[/\A */].length

      break if !stripped.empty? && indent <= base && !stripped.start_with?("strong", "em", "b", "|", "a.lnk", "p", "code", "br")

      if stripped.start_with?("strong") || stripped.start_with?("b ")
        @i += 1
        parts << "**#{collect_text(lines, indent).strip}**"
        next
      end

      if stripped.start_with?("em")
        @i += 1
        parts << "*#{collect_text(lines, indent).strip}*"
        next
      end

      if stripped.start_with?("p") && !stripped.start_with?("path")
        parts << parse_paragraph(lines)
        next
      end

      if stripped.start_with?("|") || stripped.start_with?("a.lnk") || stripped.start_with?("= link_to")
        parts << collect_text(lines, indent)
        @i += 1
        next
      end

      if stripped.start_with?("code")
        @i += 1
        parts << "`#{collect_text(lines, indent).strip}`"
        next
      end

      if stripped == "br"
        parts << "\n\n"
        @i += 1
        next
      end

      break if !stripped.empty? && indent <= base
      @i += 1
    end

    parts.join(" ").squeeze(" ").strip
  end

  def collect_text(lines, base)
    parts = []

    while @i < lines.length
      line = lines[@i]
      stripped = line.strip
      indent = line[/\A */].length

      break if !stripped.empty? && indent < base

      if stripped.start_with?("|")
        parts << stripped.delete_prefix("|").strip
        @i += 1
        next
      end

      if stripped.start_with?("strong") || stripped == "strong"
        @i += 1
        parts << "**#{collect_text(lines, indent).strip}**"
        next
      end

      if stripped.start_with?("em")
        @i += 1
        parts << "*#{collect_text(lines, indent).strip}*"
        next
      end

      if stripped.start_with?("b ")
        @i += 1
        parts << "**#{collect_text(lines, indent).strip}**"
        next
      end

      if stripped.start_with?("a.lnk")
        parts << parse_link_line(stripped)
        @i += 1
        next
      end

      if stripped.start_with?("= link_to") || stripped.start_with?("[")
        parts << stripped.sub(/\A=\s*link_to\s+/, "")
        @i += 1
        next
      end

      if stripped.start_with?("code")
        @i += 1
        parts << "`#{collect_text(lines, indent).strip}`"
        next
      end

      if stripped == "br"
        parts << "\n\n"
        @i += 1
        next
      end

      break if !stripped.empty? && indent == base && !stripped.start_with?("|")
      break if !stripped.empty? && indent <= base
      @i += 1
    end

    parts.join(" ").squeeze(" ").strip
  end

  def parse_link_line(stripped)
    if stripped =~ /a\.lnk\s+href="([^"]+)"(?:\s+target="_blank")?\s+(.+)/
      url = Regexp.last_match(1)
      label = Regexp.last_match(2).strip
      "[#{label}](#{url})"
    else
      stripped
    end
  end

  def parse_inline_link(lines)
    line = lines[@i].strip
    @i += 1
    if line.start_with?("a.lnk")
      parse_link_line(line)
    else
      line.sub(/\A=\s*link_to\s+/, "")
    end
  end

  def parse_standalone_image(line)
    img = extract_image_tag(line)
    "::: figure\n![#{img[:alt]}](#{img[:src]})\n:::"
  end

  def extract_image_tag(line)
    src = line[/image_tag\s+"([^"]+)"/, 1] || line[/image_tag\s+'([^']+)'/, 1]
    alt = line[/alt:\s*"([^"]*)"/, 1] || line[/alt:\s*'([^']*)'/, 1] || ""
    { src: src, alt: alt }
  end

  def parse_html_block(lines, base_indent)
    start = @i
    block_lines = []

    while @i < lines.length
      line = lines[@i]
      indent = line[/\A */].length
      break if @i > start && !line.strip.empty? && indent <= base_indent

      block_lines << line
      @i += 1
    end

    slim_to_html(block_lines)
  end

  def slim_to_html(block_lines)
    html_lines = []
    i = 0

    while i < block_lines.length
      line = block_lines[i]
      stripped = line.strip
      indent = line[/\A */].length

      if stripped.empty?
        i += 1
        next
      end

      if stripped.start_with?("/")
        i += 1
        next
      end

      if (heading = parse_heading(line))
        level = heading[/\A(#+)/, 1].length
        tag = "h#{level}"
        if heading =~ /\{#([^}]+)\}/
          id = Regexp.last_match(1)
          title = heading.sub(/\s*\{#[^}]+\}\z/, "").sub(/\A#+\s*/, "")
          html_lines << "#{" " * (indent)}<#{tag} id=\"#{id}\">#{ERB::Util.html_escape(title)}</#{tag}>"
        else
          title = heading.sub(/\A#+\s*/, "")
          html_lines << "#{" " * (indent)}<#{tag}>#{ERB::Util.html_escape(title)}</#{tag}>"
        end
        i += 1
        next
      end

      if stripped.start_with?(".")
        tag, attrs = parse_slim_tag(stripped)
        i += 1
        child_indent = block_lines[i]&.[](/\A */)&.length || indent + 2

        if %w[div nav ul ol li button span].include?(tag) || stripped.start_with?(".tab-panel", ".manual-tab", ".manual-tabs", ".manual-tab-nav", ".tab-content", ".spec-grid", ".spec-card", ".fimg", ".figure")
          children = []
          while i < block_lines.length && (block_lines[i].strip.empty? || block_lines[i][/\A */].length >= child_indent)
            if block_lines[i].strip.empty?
              i += 1
              next
            end
            break if block_lines[i][/\A */].length <= indent && !block_lines[i].strip.empty?

            sub = extract_subtree(block_lines, i, indent)
            children << sub[:html]
            i = sub[:next_index]
          end
          html_lines << "#{" " * indent}<#{tag}#{attrs}>#{children.join}\n#{" " * indent}</#{tag}>"
          next
        end
      end

      if stripped.start_with?("= image_tag")
        img = extract_image_tag(stripped)
        html_lines << "#{" " * indent}<img src=\"#{img[:src]}\" alt=\"#{ERB::Util.html_escape(img[:alt])}\" class=\"doc-img\">"
        i += 1
        next
      end

      if stripped.start_with?("button.")
        if stripped =~ /button\.([^\s]+)(?:\s+type="([^"]+)")?(.*)/
          classes = Regexp.last_match(1)
          type = Regexp.last_match(2) || "button"
          rest = Regexp.last_match(3)
          i += 1
          text = block_lines[i]&.strip&.delete_prefix("|")&.strip
          i += 1 if text
          html_lines << "#{" " * indent}<button type=\"#{type}\" class=\"#{classes}\"#{rest}>#{text}</button>"
          next
        end
      end

      if stripped.start_with?("|")
        html_lines << "#{" " * indent}<p>#{ERB::Util.html_escape(stripped.delete_prefix("|").strip)}</p>"
        i += 1
        next
      end

      if stripped.start_with?("strong") || stripped.start_with?("b ")
        i += 1
        text = collect_text_from_array(block_lines, i - 1, indent)
        i = text[:next_index]
        html_lines << "#{" " * indent}<strong>#{text[:content]}</strong>"
        next
      end

      i += 1
    end

    "<div>\n#{html_lines.join("\n")}\n</div>"
  end

  def extract_subtree(block_lines, start_index, parent_indent)
    line = block_lines[start_index]
    stripped = line.strip
    indent = line[/\A */].length

    if stripped.start_with?(".callout.")
      type = stripped[/\.callout\.(\w+)/, 1]
      i = start_index + 1
      title = nil
      body = []
      while i < block_lines.length
        l = block_lines[i]
        break if !l.strip.empty? && l[/\A */].length <= indent
        s = l.strip
        if s.start_with?("b ")
          title = s.delete_prefix("b ").strip
        elsif s.start_with?("|")
          body << s.delete_prefix("|").strip
        end
        i += 1
      end
      label = title ? "<b>#{ERB::Util.html_escape(title)}</b> " : ""
      html = <<~HTML.strip
        <div class="callout #{type}">
          <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 9v4m0 4h.01M10.3 3.6 2.6 17a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/></svg>
          <div>#{label}#{body.join(" ")}</div>
        </div>
      HTML
      return { html: "#{" " * indent}#{html}", next_index: i }
    end

    if stripped.start_with?(".")
      tag, attrs = parse_slim_tag(stripped)
      i = start_index + 1
      children = []
      while i < block_lines.length
        l = block_lines[i]
        break if !l.strip.empty? && l[/\A */].length <= indent
        sub = extract_subtree(block_lines, i, indent)
        children << sub[:html]
        i = sub[:next_index]
      end
      html = "#{" " * indent}<#{tag}#{attrs}>#{children.join}\n#{" " * indent}</#{tag}>"
      return { html: html, next_index: i }
    end

    if stripped.start_with?("= image_tag")
      img = extract_image_tag(stripped)
      return {
        html: "#{" " * indent}<img src=\"#{img[:src]}\" alt=\"#{ERB::Util.html_escape(img[:alt])}\" class=\"doc-img\">",
        next_index: start_index + 1
      }
    end

    if stripped.start_with?("button.")
      i = start_index + 1
      text = block_lines[i]&.strip&.delete_prefix("|")&.strip
      classes = stripped[/button\.([^\s]+)/, 1]
      rest = stripped.sub(/button\.[^\s]+/, "").strip
      html = "#{" " * indent}<button class=\"#{classes}\"#{rest}>#{text}</button>"
      return { html: html, next_index: i + 1 }
    end

    if stripped.start_with?("|")
      return {
        html: "#{" " * indent}#{ERB::Util.html_escape(stripped.delete_prefix("|").strip)}",
        next_index: start_index + 1
      }
    end

    if stripped.start_with?("strong") || stripped.start_with?("b ")
      text = stripped.sub(/\A(?:strong|b)\s*/, "")
      if text.empty? && block_lines[start_index + 1]&.strip&.start_with?("|")
        text = block_lines[start_index + 1].strip.delete_prefix("|").strip
        return { html: "#{" " * indent}<strong>#{ERB::Util.html_escape(text)}</strong>", next_index: start_index + 2 }
      end
      return { html: "#{" " * indent}<strong>#{ERB::Util.html_escape(text)}</strong>", next_index: start_index + 1 }
    end

    if stripped.start_with?("li")
      i = start_index + 1
      parts = []
      while i < block_lines.length && (block_lines[i][/\A */].length > indent || block_lines[i].strip.empty?)
        s = block_lines[i].strip
        break if !s.empty? && block_lines[i][/\A */].length <= indent
        if s.start_with?("|")
          parts << ERB::Util.html_escape(s.delete_prefix("|").strip)
        elsif s.start_with?("strong") || s.start_with?("b ")
          sub = extract_subtree(block_lines, i, indent + 2)
          parts << sub[:html]
          i = sub[:next_index]
          next
        end
        i += 1
      end
      return { html: "#{" " * indent}<li>#{parts.join(" ")}</li>", next_index: i }
    end

    { html: "", next_index: start_index + 1 }
  end

  def collect_text_from_array(lines, start_index, base)
    i = start_index + 1
    parts = []
    while i < lines.length
      s = lines[i].strip
      ind = lines[i][/\A */].length
      break if !s.empty? && ind <= base
      if s.start_with?("|")
        parts << s.delete_prefix("|").strip
      end
      i += 1
    end
    { content: ERB::Util.html_escape(parts.join(" ")), next_index: i }
  end

  def parse_slim_tag(stripped)
    if stripped =~ /\A\.([^\s#]+)(?:#([^\s.]+))?(.*)\z/
      name = Regexp.last_match(1).tr(".", " ")
      id = Regexp.last_match(2)
      rest = Regexp.last_match(3).to_s

      classes = name.split.map { |c| c unless c == "hidden" }.compact
      attrs = []
      attrs << " id=\"#{id}\"" if id
      attrs << " class=\"#{classes.join(" ")}\"" if classes.any?
      attrs << " #{rest.strip}" if !rest.strip.empty?

      tag = case name.split.first
            when "manual", "tab", "panel", "content", "nav", "figure", "fimg", "spec", "grid", "card", "tr", "tk", "tv"
              if name.start_with?("manual-tabs") then "div"
              elsif name.start_with?("manual-tab-nav") then "div"
              elsif name.start_with?("manual-tab") then "button"
              elsif name.start_with?("tab-content") then "div"
              elsif name.start_with?("tab-panel") then "div"
              elsif name.start_with?("spec-grid") then "div"
              elsif name.start_with?("spec-card") then "div"
              elsif name.start_with?("figure") then "div"
              elsif name.start_with?("fimg") then "div"
              else "div"
              end
            else
              "div"
            end

      [tag, attrs.join]
    else
      ["div", ""]
    end
  end

  def cleanup(text)
    text.gsub(/\n{3,}/, "\n\n").strip + "\n"
  end
end

root = File.expand_path("..", __dir__)
ManualSlimConverter.convert_all(root)
