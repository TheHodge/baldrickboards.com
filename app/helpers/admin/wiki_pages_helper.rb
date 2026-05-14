module Admin::WikiPagesHelper
  # MediaWiki-style: [[Page slug or title]] or [[target|Link label]]
  WIKI_LINK = /\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/

  # Renders Action Text HTML with wiki [[...]] markers in text nodes turned into internal links.
  def render_wiki_page_body(wiki_page)
    html = wiki_page.body.to_s
    html = transform_wiki_links_in_html(html)
    html.html_safe
  end

  private

  def transform_wiki_links_in_html(html)
    return html if html.blank?

    fragment = Nokogiri::HTML::DocumentFragment.parse(html)
    fragment.traverse do |node|
      next unless node.text?
      next if node.ancestors.any? { |a| %w[pre code script style textarea a].include?(a.name) }

      original = node.content
      next unless original.include?("[[")

      replaced = replace_wiki_markers(original)
      next if replaced == original

      node.replace(Nokogiri::HTML::DocumentFragment.parse(replaced))
    end
    fragment.to_html
  end

  def replace_wiki_markers(text)
    text.gsub(WIKI_LINK) do
      target = Regexp.last_match(1).strip
      label = Regexp.last_match(2)&.strip
      page = WikiPage.find_for_wiki_link(target)
      display = (label.presence || page&.title || target)

      if page
        href = admin_wiki_page_path(wiki_path: page.url_path)
        %(<a href="#{ERB::Util.html_escape(href)}" class="wiki-internal-link text-indigo-600 underline hover:text-indigo-800">#{ERB::Util.html_escape(display)}</a>)
      else
        tip = ERB::Util.html_escape("No page matches: #{target}")
        %(<span class="wiki-broken-link text-amber-800 border-b border-dotted border-amber-600 cursor-help" title="#{tip}">#{ERB::Util.html_escape(display)}</span>)
      end
    end
  end
end
