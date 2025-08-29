module BoardsHelper
  # Generic method to generate menu items for any board
  def board_menu_items(board_name)
    base_items = [
      { title: 'Overview', path: "/boards/#{board_name}" },
      { title: 'Tech Specs', path: "/boards/#{board_name}/tech-specs" },
      { title: 'Getting Started', path: "/boards/#{board_name}/getting-started" }
    ]
    
    # Add Web Interface for all boards except BaldrickBadge
    unless board_name == 'baldrickbadge'
      base_items << { title: 'Web Interface', path: "/boards/#{board_name}/web-interface" }
    end
    
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
      breadcrumbs << { title: board_name.titleize, path: "/boards/#{board_name}" }
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
      { feature: 'Pixels per Output', value: 'Up to 750 pixels at 40fps' },
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

  # Generate a board card HTML
  def board_card(board_id, options = {})
    data = board_data[board_id]
    return '' unless data

    # Default options
    options = {
      show_button: true,
      hover_effect: true
    }.merge(options)

    # CSS classes
    card_classes = "bg-gray-50 rounded-lg border border-gray-200 overflow-hidden group"
    if options[:hover_effect]
      card_classes += " hover:shadow-lg hover:border-purple-300 hover:bg-purple-50 transition-all duration-300 transform hover:-translate-y-1"
    end

    # Image section
    image_section = if data[:placeholder]
      content_tag(:div, class: "h-48 bg-gray-200 overflow-hidden flex items-center justify-center") do
        content_tag(:div, class: "text-gray-400 text-center") do
          content_tag(:svg, class: "h-16 w-16 mx-auto mb-2", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
            content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: data[:icon_svg])
          end +
          content_tag(:p, "Image Coming Soon", class: "text-sm")
        end
      end
    else
      content_tag(:div, class: "h-48 bg-gray-200 overflow-hidden") do
        image_tag(data[:image], alt: "#{data[:name]} Controller Board", class: "w-full h-full object-cover")
      end
    end

    # Button section
    button_section = if options[:show_button]
      link_to("Learn More", board_path(board_id), class: "inline-block bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition-colors")
    else
      ''
    end

    # Main card content
    card_content = content_tag(:div, class: "p-6") do
      content_tag(:div, class: "mb-4") do
        content_tag(:h3, data[:name], class: "text-lg font-semibold text-gray-900 group-hover:text-purple-900 transition-colors duration-300") +
        content_tag(:span, data[:subtitle], class: "text-sm text-gray-500 group-hover:text-purple-600 transition-colors duration-300")
      end +
      content_tag(:p, data[:description], class: "text-gray-600 mb-4 group-hover:text-gray-700 transition-colors duration-300") +
      button_section
    end

    # Always wrap the entire card content in a link
    content_tag(:div, class: card_classes) do
      link_to(board_path(board_id), class: "block no-underline") do
        image_section + card_content
      end
    end
  end
end
