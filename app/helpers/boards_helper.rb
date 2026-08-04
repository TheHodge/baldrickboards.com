module BoardsHelper
  # Generic method to generate menu items for any board
  def board_menu_items(board_name)
    base_items = [
      { title: 'Overview', path: "/boards/#{board_name}" },
      { title: 'Manual & Docs', path: "/boards/#{board_name}/manual" }
    ]
    
    # Add board-specific custom menu items between Web Interface and FAQ
    custom_items = board_specific_menu_items(board_name)
    
    remaining_items = [
      { title: 'FAQ', path: "/boards/#{board_name}/faq" },
      { title: 'Buy This Board!', path: "/boards/#{board_name}/buy-this-board" }
    ]
    
    base_items + custom_items + remaining_items
  end
  
  # Method to add board-specific menu items
  def board_specific_menu_items(board_name)
    case board_name
    when 'baldrick8'
      [
        # Add any Baldrick8 specific menu items here
        # Example: { title: 'Custom Feature', path: "/boards/#{board_name}/custom-feature" }
        # { title: 'Advanced Setup', path: "/boards/#{board_name}/advanced-setup" },
        # { title: 'Troubleshooting', path: "/boards/#{board_name}/troubleshooting" }
      ]
    when 'baldrick17'
      [
        # Add any Baldrick17 specific menu items here
      ]
    when 'baldrickswitchy'
      [
        # Add any BaldrickSwitchy specific menu items here
      ]
    when 'baldrickdmx'
      [
        # Add any BaldrickDMX specific menu items here
      ]
    when 'baldrickinput1'
      [
        # Add any BaldrickInput1 specific menu items here
      ]
    when 'baldrickinput8'
      [
        # Add any BaldrickInput8 specific menu items here
      ]
    when 'baldrickbadge'
      [
        # Add any BaldrickBadge specific menu items here
      ]
    # BaldrickBuck removed - not ready for launch
    when 'baldricksignals'
      [
        # Add any BaldrickSignals specific menu items here
      ]
    else
      []
    end
  end

  # Convenience methods for specific boards (for backward compatibility)
  def baldrick8_menu_items
    board_menu_items('baldrick8')
  end

  def baldrick17_menu_items
    board_menu_items('baldrick17')
  end

  def baldrickswitchy_menu_items
    board_menu_items('baldrickswitchy')
  end

  def baldrickdmx_menu_items
    board_menu_items('baldrickdmx')
  end

  def baldrickinput1_menu_items
    board_menu_items('baldrickinput1')
  end

  def baldrickinput8_menu_items
    board_menu_items('baldrickinput8')
  end

  def baldrickbadge_menu_items
    board_menu_items('baldrickbadge')
  end

  # BaldrickBuck removed - not ready for launch

  def baldricksignals_menu_items
    board_menu_items('baldricksignals')
  end
  
  # Helper method to generate breadcrumbs for board pages
  def board_breadcrumbs(board_name, current_page = nil)
    breadcrumbs = [
      { title: 'Home', path: '/' },
      { title: 'Boards', path: '/boards' }
    ]
    
    # Add board name if we're on a board page
    if board_name.present?
      breadcrumbs << { title: t("boards.#{board_name}.name"), path: "/boards/#{board_name}" }
    end
    
    # Add current page if specified
    if current_page.present?
      breadcrumbs << { title: current_page, path: nil }
    end
    
    breadcrumbs
  end
  
  # General breadcrumb helper for any page
  def page_breadcrumbs(*items)
    breadcrumbs = []
    
    items.each_with_index do |item, index|
      if item.is_a?(Hash)
        breadcrumbs << item
      elsif item.is_a?(String)
        # If it's the last item, it's the current page (no link)
        if index == items.length - 1
          breadcrumbs << { title: item, path: nil }
        else
          # This should be a title, but we need a path too
          breadcrumbs << { title: item, path: '#' }
        end
      end
    end
    
    breadcrumbs
  end
  
  # Technical specifications for Baldrick8
  def baldrick8_tech_specs
    [
      { feature: 'Outputs', value: '8 independent pixel outputs' },
      { feature: 'Pixels per Output', value: 'Up to 750 RGB pixels at 40fps' },
      { feature: 'Protocol Support', value: 'WS2811, WS2812B, SK6812' },
      { feature: 'Power Input', value: '5V-24V DC, 2 power inputs' },
      { feature: 'Communication', value: 'Ethernet, WiFi' },
      { feature: 'Dimensions', value: '100mm x 60mm x 20mm' },
      { feature: 'Compatibility', value: 'DDP, Artnet, E1.31 & sACN' },
      { feature: 'Buttons', value: '3 Programmable Button ports' }
    ]
  end

  # Board data for category pages
  def board_data
    # List of all available boards
    board_ids = %w[baldrick8 baldrick17 baldrickswitchy baldrickdmx baldrickinput1 baldrickinput8 baldrickbadge baldricksignals]
    
    board_ids.each_with_object({}) do |board_id, data|
      # Get I18n data for this board
      i18n_data = I18n.t("boards.#{board_id}")
      
      data[board_id] = {
        name: i18n_data[:name],
        subtitle: i18n_data[:subtitle],
        description: i18n_data[:description],
        image: "#{board_id}/board.png"  # Generate image path automatically
      }
    end
  end

  # Get board overview data from I18n
  def board_overview_data(board_id)
    I18n.t("boards.#{board_id}.overview")
  end

  def board_tech_specs_rows(board_id)
    I18n.t("boards.#{board_id}.tech_specs", default: [])
  end

  def board_faq_questions(board_id)
    key = "views.boards.#{board_id}.faq.content.questions"
    return [] unless I18n.exists?(key)

    I18n.t(key).values
  end

  def board_manual_sections(board_id)
    board_manual_entries(board_id)
  end

  def board_manual_toc(board_id)
    board_manual_sections(board_id).map do |section|
      items = []
      if section[:specs_table] && board_tech_specs_rows(board_id).present?
        items << { id: "at-a-glance", title: "At a glance" }
      end
      items.concat(ManualMarkdown.toc_entries(section[:path].read))
      section.merge(items: items)
    end
  end

  def board_manual_entries(board_id)
    dir = Rails.root.join("content/manuals", board_id)
    return [] unless dir.directory?

    dir.each_child
       .select { |entry| entry.file? && entry.extname == ".md" }
       .map { |path| parse_board_manual_entry(path) }
       .sort_by { |entry| [entry[:order], entry[:slug]] }
  end

  def board_manual_updated_at(board_id)
    board_manual_entries(board_id)
      .filter_map { |entry| entry[:path].mtime if entry[:path].exist? }
      .max
  end

  def board_manual_updated_label(board_id)
    time = board_manual_updated_at(board_id)
    return nil unless time

    time.strftime("%-d %b %Y")
  end

  def board_manual_image(board_id)
    image = board_data.fetch(board_id)[:image]
    return image if Rails.root.join("app/assets/images", image).exist?

    "#{board_id}.png"
  end

  def parse_board_manual_entry(path)
    basename = path.basename(".md").to_s
    order, slug = parse_board_manual_filename(basename)
    parsed = ManualMarkdown.parse_front_matter(path.read)
    metadata = parsed[:metadata]

    {
      order: order,
      slug: slug,
      id: metadata.fetch("id", slug.tr("_", "-")),
      title: metadata.fetch("title", slug.tr("_", " ").capitalize),
      path: path,
      specs_table: metadata.fetch("specs_table", slug == "tech_specs")
    }
  end

  def parse_board_manual_filename(basename)
    if (match = basename.match(/\A(\d+)_(.+)\z/))
      [match[1].to_i, match[2]]
    else
      [999, basename]
    end
  end

  def render_board_manual_section(section)
    ManualMarkdown.render(section[:path].read, view_context: self)
  end

  def board_manual_subtitle(board_id)
    name = board_data.fetch(board_id)[:name]
    "Everything you need to wire, network and run your #{name} — from first power-up to your first show."
  end

  def board_faq_meta(board_id)
    name = board_data.fetch(board_id)[:name]
    base = "views.boards.#{board_id}.faq"

    {
      page_title: I18n.t("#{base}.title", default: "FAQ - #{name} - Baldrick Board Documentation"),
      header_title: I18n.t("#{base}.header.title", default: 'Frequently Asked Questions'),
      header_subtitle: I18n.t("#{base}.header.subtitle", default: "Common questions about #{name}"),
      content_title: I18n.t("#{base}.content.title", default: "#{name} FAQ"),
      content_description: I18n.t("#{base}.content.description", default: "Find answers to the most commonly asked questions about the #{name} controller.")
    }
  end

  def board_faq_empty_message(board_id)
    name = board_data.fetch(board_id)[:name]
    case board_id
    when 'baldrickbadge'
      "This is something we designed for a one-off event, so we don't have FAQ content yet — we'll add questions here if they come up."
    when 'baldrick17'
      "The Baldrick17 hasn't been released yet, so we don't have FAQ content at this time. Check the manual for setup and usage details."
    else
      "We don't have FAQ content for the #{name} yet. Check the manual or post a triage case if you need help."
    end
  end

  def board_faq_coming_soon(board_id)
    base = "views.boards.#{board_id}.faq.content.coming_soon"
    return unless I18n.exists?("#{base}.content")

    {
      title: I18n.t("#{base}.title", default: 'Coming soon'),
      body: board_faq_coming_soon_html(board_id)
    }
  end

  def board_faq_coming_soon_html(board_id)
    key = "views.boards.#{board_id}.faq.content.coming_soon.content"
    return unless I18n.exists?(key)

    html = I18n.t(key).to_s
    html = html.gsub(%r{/boards/#{board_id}/getting-started}, board_page_path(board_id, 'manual', anchor: 'getting-started'))
    html = html.gsub(%r{/boards/#{board_id}/web-interface}, board_page_path(board_id, 'manual', anchor: 'web-interface'))
    html.gsub(/\sclass="[^"]*"/, '').html_safe
  end

  def board_faq_resource_links(board_id)
    links = []
    if board_manual_sections(board_id).present?
      links << {
        title: 'Manual & Docs',
        subtitle: 'Tech specs, setup and web interface',
        path: board_page_path(board_id, 'manual')
      }
    end
    links << {
      title: 'Where to buy',
      subtitle: 'Authorised vendors in your region',
      path: board_page_path(board_id, 'buy-this-board')
    }
    links << {
      title: 'Board overview',
      subtitle: 'Features, specs and quick links',
      path: board_path(board_id)
    }
    links
  end

  def board_faq_answer_html(faq)
    answer = faq[:answer].to_s
    Array(faq[:images]).each_with_index do |image, index|
      answer = answer.gsub("%{image_#{index + 1}}", image_path(image))
    end
    answer.gsub(/\sclass="[^"]*"/, '').html_safe
  end

  def board_buy_meta(board_id)
    name = board_data.fetch(board_id)[:name]
    base = "views.boards.#{board_id}.og.buy_this_board"

    {
      page_title: "Where to Buy the #{name} - Baldrick Board Documentation",
      header_title: I18n.t("#{base}.title", default: "Where to buy the #{name}"),
      header_subtitle: I18n.t("#{base}.description", default: "Get your #{name} from trusted retailers worldwide."),
      content_description: I18n.t("#{base}.description", default: "The #{name} is available from our trusted network of authorised retailers worldwide.")
    }
  end

  def board_buy_empty_message(board_id)
    name = board_data.fetch(board_id)[:name]
    case board_id
    when 'baldrickbadge'
      'The BaldrickBadge is currently only available at certain events. Contact us if you would like one at your event.'
    else
      "We don't have retailer listings for the #{name} yet. Check the main where-to-buy page or contact support."
    end
  end

  def board_buy_retailers(board_id)
    retailers.fetch(board_id, [])
  end

  WHERE_TO_BUY_BOARD_IDS = %w[
    baldrick8 baldrick17 baldrickswitchy baldrickdmx
    baldrickinput1 baldrickinput8 baldricksignals
  ].freeze

  def where_to_buy_boards
    WHERE_TO_BUY_BOARD_IDS.filter_map do |board_id|
      regions = board_buy_retailers(board_id)
      next if regions.blank?

      {
        id: board_id,
        name: board_data.fetch(board_id)[:name],
        regions: regions
      }
    end
  end

  def where_to_buy_toc
    [
      { id: 'overview', title: 'Overview', items: [] },
      {
        id: 'all-boards',
        title: 'All boards',
        items: where_to_buy_boards.map { |board| { id: board[:id], title: board[:name] } }
      },
      { id: 'partners', title: 'Retail partners', items: [] }
    ]
  end

  def retailers
    @board_retailers ||= {
      'baldrick8' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/67-baldrick-board' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-8-port-controller' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/brpixel8' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/pixel-controllers/baldrick8-pixel-controller/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldrick8' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrick8?variant=48773341610241' }
        ] }
      ],
      'baldrick17' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1699-baldrick-b17-controller.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-17-port-controller-geusa-edition' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/products/brpixel17' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/pixel-controllers/baldrick17/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-17-port-pixel-controller/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldrick17' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrick17?variant=48773467832577' }
        ] }
      ],
      'baldrickswitchy' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1455-baldrick-switchy.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-switchy' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/brswitchy' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/relay-controllers/baldrickswitchy/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-switchy/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldrickswitchy' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrickswitchy?variant=48810550329601' }
        ] }
      ],
      'baldrickdmx' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1503-baldrick-dmx.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/collections/controllers' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/brdmx' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/dmx-controllers/baldrickdmx/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-dmx/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldrickdmx' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrickdmx?variant=48808396947713' }
        ] }
      ],
      'baldrickinput1' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1516-baldrick-input-1.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-input-1' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/brinput1' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/interactive-controllers/baldrickinput1/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-input1/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldrickinput1' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrickinput1?variant=48810556129537' }
        ] }
      ],
      'baldrickinput8' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1517-baldrick-input-8.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-input-8' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/brinput8' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/interactive-controllers/baldrickinput8-interactive-controller/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-input8/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/input8' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldrickinput8?variant=48808426111233' }
        ] }
      ],
      'baldricksignals' => [
        { key: 'uk', code: 'gb', country: 'United Kingdom', vendors: [
          { name: 'Build a Light Show', url: 'https://buildalightshow.com/baldrick-board/1535-baldricksignals.html' }
        ] },
        { key: 'us', code: 'us', country: 'United States', vendors: [
          { name: 'Gilbert Engineering', url: 'https://gilbertengineeringusa.com/products/baldrick-signal?_pos=1&_sid=dd987a345&_ss=r' },
          { name: 'Wired Watts', url: 'https://www.wiredwatts.com/products/brsignal' },
          { name: 'Baldrick Store', url: 'https://www.baldrickstore.com/interactive-controllers/baldricksignals/' }
        ] },
        { key: 'au', code: 'au', country: 'Australia', vendors: [
          { name: 'Hanson Electronics', url: 'https://www.hansonelectronics.com.au/product/baldrick-signals/' }
        ] },
        { key: 'nl', code: 'nl', country: 'Netherlands', vendors: [
          { name: 'Propixeler', url: 'https://www.propixeler.nl/product/baldricksignals' }
        ] },
        { key: 'ca', code: 'ca', country: 'Canada', vendors: [
          { name: 'Light Show Factory', url: 'https://lightshowfactory.ca/en-ca/products/ilightthat-baldricksignals?variant=48810561241345' }
        ] }
      ]
    }.freeze
  end

  def category_page_config(category_key)
    configs = {
      'all_boards' => {
        title: 'All Baldrick Boards',
        subtitle: 'Explore our complete range of controller boards for pixels, DMX, relays, inputs and more.',
        eye: 'Boards',
        image: 'baldrick8/board.png',
        meta: ['8 boards', 'E1.31 / sACN', 'CE & UKCA certified'],
        boards: %w[baldrick8 baldrick17 baldrickswitchy baldrickdmx baldrickinput1 baldrickinput8 baldrickbadge baldricksignals]
      },
      'pixel_controllers' => {
        title: 'Pixel Controllers',
        subtitle: 'Professional-grade pixel control for lighting displays — from first prop to full show.',
        eye: 'Boards',
        image: 'baldrick8/board.png',
        meta: ['3 boards', 'WS2811 / SK6812 / APA102', 'CE & UKCA certified'],
        boards: %w[baldrick8 baldrick17 baldrickinput8]
      },
      'relay_controllers' => {
        title: 'Relay Controllers',
        subtitle: 'High-power relay control for AC lighting, motors and real-world effects.',
        eye: 'Boards',
        image: 'baldrickswitchy/board.png',
        meta: ['1 board', 'Up to 8A per relay', 'DDP · Art-Net · E1.31'],
        boards: %w[baldrickswitchy]
      },
      'dmx_controllers' => {
        title: 'DMX Controllers',
        subtitle: 'Professional DMX512 control for stage and event lighting.',
        eye: 'Boards',
        image: 'baldrickdmx/board.png',
        meta: ['1 board', 'DMX512 output', 'xLights ready'],
        boards: %w[baldrickdmx]
      },
      'interactive_controllers' => {
        title: 'Interactive Controllers',
        subtitle: 'Input and interaction control for visitor-triggered displays and props.',
        eye: 'Boards',
        image: 'baldrickinput8/board.png',
        meta: ['3 boards', 'Turnip Network', 'Buttons & sensors'],
        boards: %w[baldrickinput1 baldrickinput8 baldricksignals]
      },
      'portable_controllers' => {
        title: 'Portable Controllers',
        subtitle: 'Compact and portable control solutions for badges, props and small installs.',
        eye: 'Boards',
        image: 'baldrickinput1/board.png',
        meta: ['2 boards', 'USB & WiFi options', 'Small footprint'],
        boards: %w[baldrickinput1 baldrickbadge]
      },
      'power_distribution' => {
        title: 'Power Distribution',
        subtitle: 'Efficient power management and distribution solutions.',
        eye: 'Boards',
        image: 'baldrick8/board.png',
        meta: [],
        boards: []
      }
    }
    configs.fetch(category_key.to_s)
  end

  def board_category_label(board_id)
    case board_id
    when 'baldrick8', 'baldrick17' then 'Pixel Controller'
    when 'baldrickswitchy' then 'Relay Controller'
    when 'baldrickdmx' then 'DMX Controller'
    when 'baldrickinput1', 'baldrickinput8' then 'Interactive Controller'
    when 'baldrickbadge' then 'Portable Controller'
    when 'baldricksignals' then 'Signal Controller'
    else 'Controller'
    end
  end

  # Generate a board card for category catalog grids
  def board_card(board_id, options = {})
    data = board_data[board_id]
    return '' unless data

    options = { show_button: true }.merge(options)

    link_to board_path(board_id), class: 'pcard' do
      safe_join([
        content_tag(:div, class: 'shot') do
          image_tag(data[:image], alt: "#{data[:name]} board photo")
        end,
        content_tag(:div, class: 'pcard-body') do
          safe_join([
            content_tag(:h3, data[:name]),
            content_tag(:span, data[:subtitle], class: 'spec'),
            content_tag(:p, data[:description]),
            (if options[:show_button]
               content_tag(:span, class: 'btn btn-solid btn-sm') do
                 safe_join(['Learn More ', content_tag(:span, '→', class: 'ar')])
               end
             end)
          ].compact)
        end
      ])
    end
  end
end
