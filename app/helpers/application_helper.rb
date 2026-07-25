module ApplicationHelper
  # Knowledge level descriptions for triage cases
  def knowledge_level_descriptions
    {
      1 => "I saw this on a youtube video and thought this looks easy",
      2 => "I've got as far as plugging it in",
      3 => "I've got a show that works, but I don't know how",
      4 => "I still have to google which end of the pigtail to plugin",
      5 => "I'm alright at this actually",
      6 => "I've helped out others with their issues",
      7 => "I once went 5 days without crashing xLights",
      8 => "I don't even turn my show off to change pixels",
      9 => "TBG wishes he had my show",
      10 => "I know more than you"
    }
  end

  def knowledge_level_description(level)
    knowledge_level_descriptions[level] || "Unknown"
  end

  # Generate Active Storage blob URL without locale parameter
  # Uses Rails URL helpers directly to bypass default_url_options
  # Supports both blobs and variants
  def blob_url_without_locale(blob_or_variant)
    # Check if it's a variant (ActiveStorage::VariantWithRecord or similar)
    if blob_or_variant.respond_to?(:blob) && blob_or_variant.respond_to?(:variation)
      # For variants, use Rails' representation path helper
      # Use routes directly to bypass default_url_options
      Rails.application.routes.url_helpers.rails_representation_path(blob_or_variant, only_path: true)
    else
      # For regular blobs, use Rails' blob path helper
      # Use routes directly to bypass default_url_options
      Rails.application.routes.url_helpers.rails_blob_path(blob_or_variant, only_path: true)
    end
  end
  def page_breadcrumbs(*breadcrumbs)
    breadcrumbs.map.with_index do |crumb, index|
      if index == breadcrumbs.length - 1
        { name: crumb, current: true }
      else
        { name: crumb, current: false }
      end
    end
  end

  def newsletter_unsubscribe_url(email)
    Rails.application.routes.url_helpers.newsletter_subscribers_unsubscribe_url(email: email, host: Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3001')
  end

  # Render plain text comments with safe link support.
  # Supports markdown links like [label](https://example.com) and bare URLs.
  def render_comment_content(text)
    escaped = ERB::Util.html_escape(text.to_s)
    markdown_linked = escaped.gsub(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/) do
      label = Regexp.last_match(1)
      url = Regexp.last_match(2)
      %(<a href="#{url}" target="_blank" rel="noopener noreferrer">#{label}</a>)
    end

    linked = link_plain_urls(markdown_linked)
    sanitize(linked, tags: %w[a br], attributes: %w[href target rel])
  end

  # Admin menu helper
  def admin_menu_items
    [
      { title: 'Dashboard', path: admin_root_path },
      { title: 'Newsletter', path: admin_newsletter_subscribers_path },
      { title: 'Feedback', path: admin_feedbacks_path },
      { title: 'Cases', path: admin_triage_cases_path },
      { title: 'Solutions', path: admin_triage_solutions_path },
      { title: 'Search', path: admin_search_logs_path },
      { title: 'Analytics', path: admin_analytics_path },
      { title: '404s', path: admin_error_logs_path },
      { title: 'Knowledge', path: admin_wiki_pages_path }
    ]
  end

  # Country flag helper for analytics
  def country_flag(country_code)
    return '🌍' if country_code.blank? || country_code == 'Unknown'
    
    # Map common country codes to flag emojis
    flag_map = {
      'US' => '🇺🇸', 'GB' => '🇬🇧', 'CA' => '🇨🇦', 'AU' => '🇦🇺', 'DE' => '🇩🇪',
      'FR' => '🇫🇷', 'ES' => '🇪🇸', 'IT' => '🇮🇹', 'NL' => '🇳🇱', 'SE' => '🇸🇪',
      'NO' => '🇳🇴', 'DK' => '🇩🇰', 'FI' => '🇫🇮', 'CH' => '🇨🇭', 'AT' => '🇦🇹',
      'BE' => '🇧🇪', 'IE' => '🇮🇪', 'PT' => '🇵🇹', 'PL' => '🇵🇱', 'CZ' => '🇨🇿',
      'HU' => '🇭🇺', 'SK' => '🇸🇰', 'SI' => '🇸🇮', 'HR' => '🇭🇷', 'BG' => '🇧🇬',
      'RO' => '🇷🇴', 'GR' => '🇬🇷', 'CY' => '🇨🇾', 'MT' => '🇲🇹', 'LU' => '🇱🇺',
      'EE' => '🇪🇪', 'LV' => '🇱🇻', 'LT' => '🇱🇹', 'JP' => '🇯🇵', 'KR' => '🇰🇷',
      'CN' => '🇨🇳', 'IN' => '🇮🇳', 'BR' => '🇧🇷', 'MX' => '🇲🇽', 'AR' => '🇦🇷',
      'CL' => '🇨🇱', 'CO' => '🇨🇴', 'PE' => '🇵🇪', 'VE' => '🇻🇪', 'UY' => '🇺🇾',
      'ZA' => '🇿🇦', 'EG' => '🇪🇬', 'NG' => '🇳🇬', 'KE' => '🇰🇪', 'MA' => '🇲🇦',
      'RU' => '🇷🇺', 'TR' => '🇹🇷', 'IL' => '🇮🇱', 'AE' => '🇦🇪', 'SA' => '🇸🇦',
      'TH' => '🇹🇭', 'VN' => '🇻🇳', 'ID' => '🇮🇩', 'MY' => '🇲🇾', 'SG' => '🇸🇬',
      'PH' => '🇵🇭', 'NZ' => '🇳🇿'
    }
    
    flag_map[country_code.upcase] || '🌍'
  end

  # Open Graph helpers with hierarchical I18n fallback
  def og_title
    content_for(:og_title) || og_i18n_value('title') || content_for(:title) || t('og.default_title')
  end

  def og_description
    content_for(:og_description) || og_i18n_value('description') || content_for(:title) || t('og.default_description')
  end

  def og_image
    content_for(:og_image) || og_image_url(og_i18n_value('image')) || og_image_url('og-default')
  end

  def og_url
    content_for(:og_url) || request.original_url
  end

  def og_type
    content_for(:og_type) || t('og.type')
  end

  def og_site_name
    t('og.site_name')
  end

  def og_locale
    t('og.locale')
  end

  def twitter_card
    content_for(:twitter_card) || t('og.twitter_card')
  end

  def twitter_site
    content_for(:twitter_site) || t('og.twitter_site')
  end

  def twitter_title
    content_for(:twitter_title) || og_title
  end

  def twitter_description
    content_for(:twitter_description) || og_description
  end

  def twitter_image
    content_for(:twitter_image) || og_image
  end

  # Helper to set Open Graph data in views
  def set_og_data(options = {})
    content_for(:og_title, options[:title]) if options[:title]
    content_for(:og_description, options[:description]) if options[:description]
    content_for(:og_image, options[:image]) if options[:image]
    content_for(:og_url, options[:url]) if options[:url]
    content_for(:og_type, options[:type]) if options[:type]
    content_for(:twitter_card, options[:twitter_card]) if options[:twitter_card]
    content_for(:twitter_site, options[:twitter_site]) if options[:twitter_site]
    content_for(:twitter_title, options[:twitter_title]) if options[:twitter_title]
    content_for(:twitter_description, options[:twitter_description]) if options[:twitter_description]
    content_for(:twitter_image, options[:twitter_image]) if options[:twitter_image]
  end

  private

  def link_plain_urls(text)
    text.gsub(%r{(?<!["'>])(https?://[^\s<]+)}) do
      url = Regexp.last_match(1)
      %(<a href="#{url}" target="_blank" rel="noopener noreferrer">#{url}</a>)
    end
  end

  # Helper to generate Open Graph image URLs using asset pipeline with full URLs
  def og_image_url(image_key)
    return nil if image_key.blank?
    
    # If it's already a full URL, return as-is
    return image_key if image_key.start_with?('http')
    
    # Use asset pipeline for Open Graph images with full URL
    begin
      if image_key.start_with?('/')
        # Handle absolute paths (legacy support)
        image_key
      else
        # Use asset pipeline to generate full URL
        asset_url("#{image_key}.jpg")
      end
    rescue => e
      # Fallback to default if image doesn't exist
      Rails.logger.warn "Open Graph image not found: #{image_key}.jpg, falling back to default. Error: #{e.message}"
      asset_url("og-default.jpg")
    end
  end

  # Helper to get Open Graph values from I18n with hierarchical fallback
  def og_i18n_value(field)
    # Try to determine the current page context from the controller and action
    controller_name = controller.controller_name
    action_name = controller.action_name
    
    # Build I18n keys to try in order of specificity
    i18n_keys = []
    
    # For board-specific pages (using the boards controller)
    if controller_name == 'boards' && params[:board]
      board_name = params[:board]
      page_name = params[:page]
      
      # Most specific: board + page from board-specific I18n file (e.g., views.boards.baldrick8.og.faq.title)
      if page_name.present?
        # Convert URL format to I18n format: buy-this-board -> buy_this_board
        i18n_page_name = page_name.gsub('-', '_')
        i18n_keys << "views.boards.#{board_name}.og.#{i18n_page_name}.#{field}"
      end
      
      # Less specific: board only from board-specific I18n file (e.g., views.boards.baldrick8.og.title)
      i18n_keys << "views.boards.#{board_name}.og.#{field}"
    end
    
    # For general pages
    case controller_name
    when 'pages'
      case action_name
      when 'home'
        i18n_keys << "og.pages.home.#{field}"
      when 'where_to_buy'
        i18n_keys << "og.pages.where_to_buy.#{field}"
      end
    when 'faq'
      i18n_keys << "og.pages.faq.#{field}"
    when 'support'
      i18n_keys << "og.pages.support.#{field}"
    when 'testimonials'
      i18n_keys << "og.pages.testimonials.#{field}"
    when 'about'
      i18n_keys << "og.pages.about.#{field}"
    when 'boards'
      case action_name
      when 'index'
        i18n_keys << "og.pages.boards.#{field}"
      when 'pixel_controllers'
        i18n_keys << "og.pages.boards.pixel_controllers.#{field}"
      when 'relay_controllers'
        i18n_keys << "og.pages.boards.relay_controllers.#{field}"
      when 'interactive_controllers'
        i18n_keys << "og.pages.boards.interactive_controllers.#{field}"
      when 'portable_controllers'
        i18n_keys << "og.pages.boards.portable_controllers.#{field}"
      when 'power_distribution'
        i18n_keys << "og.pages.boards.power_distribution.#{field}"
      when 'dmx_controllers'
        i18n_keys << "og.pages.boards.dmx_controllers.#{field}"
      end
    when 'breakthroughs'
      case action_name
      when 'index'
        i18n_keys << "og.pages.breakthroughs.#{field}"
      when 'turnip_network'
        i18n_keys << "og.pages.breakthroughs.turnip_network.#{field}"
      when 'kluster'
        i18n_keys << "og.pages.breakthroughs.kluster.#{field}"
      when 'ce_ukca_certification'
        i18n_keys << "og.pages.breakthroughs.ce_ukca_certification.#{field}"
      when 'turniput'
        i18n_keys << "og.pages.breakthroughs.turniput.#{field}"
      when 'hodgical_test_mode'
        i18n_keys << "og.pages.breakthroughs.hodgical_test_mode.#{field}"
      when 'cunningfx'
        i18n_keys << "og.pages.breakthroughs.cunningfx.#{field}"
      end
    when 'fun_stuff'
      case action_name
      when 'index'
        i18n_keys << "og.pages.fun_stuff.#{field}"
      when 'release_notes'
        i18n_keys << "og.pages.fun_stuff.release_notes.#{field}"
      when 'stls_and_mounts'
        i18n_keys << "og.pages.fun_stuff.stls_and_mounts.#{field}"
      when 'board_dimensions'
        i18n_keys << "og.pages.fun_stuff.board_dimensions.#{field}"
      when 'faq'
        i18n_keys << "og.pages.fun_stuff.faq.#{field}"
      when 'problem_solver'
        i18n_keys << "og.pages.fun_stuff.problem_solver.#{field}"
      when 'panic_mode'
        i18n_keys << "og.pages.fun_stuff.panic_mode.#{field}"
      when 'testimonials'
        i18n_keys << "og.pages.fun_stuff.testimonials.#{field}"
      when 'customer_showcase'
        i18n_keys << "og.pages.fun_stuff.customer_showcase.#{field}"
      end
    end
    
    # Try each key until we find a value
    i18n_keys.each do |key|
      begin
        value = t(key)
        return value unless value.include?('translation missing')
      rescue I18n::MissingTranslationData
        # Continue to next key
      end
    end
    
    nil
  end
end
