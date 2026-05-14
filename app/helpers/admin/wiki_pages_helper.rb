module Admin::WikiPagesHelper
  # MediaWiki-style: [[Page slug or title]] or [[target|Link label]]
  WIKI_LINK = /\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/

  # Renders Action Text HTML with wiki [[...]] markers in text nodes turned into internal links.
  def render_wiki_page_body(wiki_page)
    html = wiki_page.body.to_s
    html = transform_wiki_links_in_html(html)
    html.html_safe
  end

  # Builds `breadcrumbs` for `shared/admin_breadcrumbs` (Admin > …).
  def admin_knowledge_breadcrumbs(mode:, wiki_page: nil)
    case mode.to_sym
    when :index
      [{ name: "Knowledge", url: nil }]
    when :formatting_guide
      [
        { name: "Knowledge", url: admin_wiki_pages_path },
        { name: "Formatting guide", url: nil }
      ]
    when :show
      chain = wiki_page.breadcrumb_chain
      items = [{ name: "Knowledge", url: admin_wiki_pages_path }]
      chain[0..-2].each do |p|
        items << { name: p.title, url: admin_wiki_page_path(wiki_path: p.url_path) }
      end
      items << { name: wiki_page.title, url: nil }
      items
    when :edit
      chain = wiki_page.breadcrumb_chain
      items = [{ name: "Knowledge", url: admin_wiki_pages_path }]
      chain[0..-2].each do |p|
        items << { name: p.title, url: admin_wiki_page_path(wiki_path: p.url_path) }
      end
      items << { name: wiki_page.title, url: admin_wiki_page_path(wiki_path: wiki_page.url_path) }
      items << { name: "Edit", url: nil }
      items
    when :new
      items = [{ name: "Knowledge", url: admin_wiki_pages_path }]
      WikiPage.breadcrumb_chain_for_parent_id(wiki_page&.parent_id).each do |p|
        items << { name: p.title, url: admin_wiki_page_path(wiki_path: p.url_path) }
      end
      items << { name: "New page", url: nil }
      items
    else
      [{ name: "Knowledge", url: admin_wiki_pages_path }]
    end
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
        href = ERB::Util.html_escape(new_admin_wiki_page_path(missing_wiki_target: target))
        tip = ERB::Util.html_escape("No page yet — click to create: #{target}")
        %(<a href="#{href}" class="wiki-missing-page-link text-amber-800 underline decoration-dotted decoration-amber-600 hover:text-amber-950" title="#{tip}">#{ERB::Util.html_escape(display)}</a>)
      end
    end
  end
end
