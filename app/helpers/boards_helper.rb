module BoardsHelper
  # Generic method to generate menu items for any board
  def board_menu_items(board_name)
    base_items = [
      { title: 'Overview', path: "/boards/#{board_name}" },
      { title: 'Tech Specs', path: "/boards/#{board_name}/tech-specs" },
      { title: 'Getting Started', path: "/boards/#{board_name}/getting-started" },
      { title: 'Web Interface', path: "/boards/#{board_name}/web-interface" }
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
    {
      'baldrick8' => {
        name: 'Baldrick8',
        subtitle: '8 Outputs',
        description: '8-channel pixel controller with precision timing and rock-solid reliability for professional lighting displays.',
        features: ['8 independent outputs', 'WS2811/WS2812B support', 'High refresh rates', 'Professional grade'],
        image: '/img/baldrick8-board.png'
      },
      'baldrick17' => {
        name: 'Baldrick17',
        subtitle: '17 Outputs',
        description: 'High-density 17-channel pixel controller for large-scale lighting installations and complex displays.',
        features: ['17 independent outputs', 'Massive pixel capacity', 'Advanced networking', 'Enterprise features'],
        image: '/img/baldrick17-board.png'
      },
      'baldrickswitchy' => {
        name: 'BaldrickSwitchy',
        subtitle: 'Relay Controller',
        description: 'High-power relay controller for AC lighting, motors, and other high-voltage applications with precise timing control.',
        features: ['AC device control', 'High-power handling', 'Precise timing control', 'Safety features'],
        image: '/img/baldrickswitchy-board.png'
      },
      'baldrickdmx' => {
        name: 'BaldrickDMX',
        subtitle: 'DMX Controller',
        description: 'Professional DMX512 controller for stage lighting, moving heads, and theatrical applications with precise timing.',
        features: ['DMX512 protocol support', 'Professional lighting control', 'Multiple universe support', 'Industry standard'],
        image: '/img/baldrickdmx-board.png'
      },
      'baldrickinput1' => {
        name: 'BaldrickInput1',
        subtitle: 'Single Input',
        description: 'Single-channel input controller for buttons, sensors, and interactive triggers with pixel output capabilities.',
        features: ['Single input handling', 'Interactive displays', 'Simple setup', 'Cost-effective'],
        image: '/img/baldrickinput1-board.png'
      },
      'baldrickinput8' => {
        name: 'BaldrickInput8',
        subtitle: '8 Inputs/8 Outputs',
        description: '8-channel input controller with pixel output capabilities for interactive installations.',
        features: ['8 input channels', 'Pixel output support', 'Interactive displays', 'Complex logic'],
        image: '/img/baldrickinput8-board.png'
      },
      # BaldrickBuck removed - not ready for launch
      'baldrickbadge' => {
        name: 'BaldrickBadge',
        subtitle: 'Badge Style',
        description: 'Compact badge-style controller for wearable and portable applications.',
        features: ['Compact form factor', 'Wearable applications', 'Battery powered', 'Portable design'],
        image: '/img/baldrickbadge-board.png'
      },
      'baldricksignals' => {
        name: 'BaldrickSignals',
        subtitle: 'Signal Controller',
        description: 'Advanced interactive signal controller for complex signaling and communication applications.',
        features: ['Advanced signal processing', 'Multi-protocol support', 'Interactive routing', 'Professional grade'],
        image: '/img/baldricksignals-board.png'
      }
    }
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
      %Q{
        <div class="h-48 bg-gray-200 overflow-hidden flex items-center justify-center">
          <div class="text-gray-400 text-center">
            <svg class="h-16 w-16 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="#{data[:icon_svg]}"></path>
            </svg>
            <p class="text-sm">Image Coming Soon</p>
          </div>
        </div>
      }
    else
      %Q{
        <div class="h-48 bg-gray-200 overflow-hidden">
          <img src="#{data[:image]}" alt="#{data[:name]} Controller Board" class="w-full h-full object-cover">
        </div>
      }
    end

    # Button section
    button_section = if options[:show_button]
      %Q{
        <a href="/boards/#{board_id}" class="inline-block bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition-colors">Learn More</a>
      }
    else
      ''
    end

    # Features list
    features_list = data[:features].map { |feature| "<li>• #{feature}</li>" }.join("\n")

    # Main card content
    card_content = %Q{
      <div class="p-6">
        <div class="mb-4">
          <h3 class="text-lg font-semibold text-gray-900 group-hover:text-purple-900 transition-colors duration-300">#{data[:name]}</h3>
          <span class="text-sm text-gray-500 group-hover:text-purple-600 transition-colors duration-300">#{data[:subtitle]}</span>
        </div>
        <p class="text-gray-600 mb-4 group-hover:text-gray-700 transition-colors duration-300">#{data[:description]}</p>
        <ul class="text-sm text-gray-600 mb-4 space-y-1 group-hover:text-gray-700 transition-colors duration-300">
          #{features_list}
        </ul>
        #{button_section}
      </div>
    }

    # Always wrap the entire card content in a link
    %Q{
      <div class="#{card_classes}">
        <a href="/boards/#{board_id}" class="block no-underline">
          #{image_section}
          #{card_content}
        </a>
      </div>
    }.html_safe
  end
end
