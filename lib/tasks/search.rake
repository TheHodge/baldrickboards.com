namespace :search do
  desc "Generate search index for all content"
  task generate_index: :environment do
    require 'json'
    require 'nokogiri'
    
    search_data = []
    
    # Helper method to extract text content from HTML
    def extract_text_content(html_content)
      return "" if html_content.nil?
      
      # Parse HTML and extract text
      doc = Nokogiri::HTML(html_content)
      
      # Remove script and style elements
      doc.css('script, style').remove
      
      # Get text content and clean it up
      text = doc.text
        .gsub(/\s+/, ' ')  # Replace multiple whitespace with single space
        .strip
      
      text
    end
    
    # Helper method to add page to search data
    def add_page_to_search(data, title, url, content, category, tags = [])
      data << {
        title: title,
        url: url,
        content: extract_text_content(content),
        category: category,
        tags: tags,
        excerpt: extract_text_content(content)[0..200] + "..."
      }
    end
    
    puts "Generating search index..."
    
    # Add main pages with detailed content
    main_pages = {
      'home' => {
        title: 'Home',
        url: '/',
        description: 'Baldrick Boards - Professional lighting control solutions for advanced displays, automation, and interactive installations. Comprehensive range of controllers including pixel controllers, relay controllers, DMX controllers, and more.',
        features: 'lighting control, pixel controllers, relay controllers, DMX controllers, automation, interactive displays'
      },
      'about' => {
        title: 'About Baldrick',
        url: '/about',
        description: 'About Baldrick Boards and our innovative approach to lighting control. Learn about our philosophy, clever design principles, and commitment to providing professional lighting solutions with a unique sense of humor.',
        features: 'philosophy, clever design, professional solutions, lighting control, innovation'
      },
      'faq' => {
        title: 'FAQ',
        url: '/faq',
        description: 'Frequently Asked Questions about Baldrick Boards. Comprehensive answers to common questions about installation, configuration, troubleshooting, and usage of Baldrick controllers.',
        features: 'frequently asked questions, installation, configuration, troubleshooting, usage, common issues'
      },
      'fun-stuff' => {
        title: 'Fun Stuff',
        url: '/fun-stuff',
        description: 'Fun Stuff and additional resources for Baldrick Boards. Release notes, STL files, board dimensions, panic mode information, and other useful resources for Baldrick enthusiasts.',
        features: 'release notes, STL files, board dimensions, panic mode, resources, enthusiasts'
      }
    }
    
    main_pages.each do |slug, data|
      content = "#{data[:description]} Features include: #{data[:features]}"
      add_page_to_search(search_data, data[:title], data[:url], content, slug == 'home' ? 'main' : slug)
    end
    
    # Add board categories
    board_categories = [
      { name: "Pixel Controllers", url: "/boards/pixel-controllers", description: "Professional pixel controllers for advanced lighting displays" },
      { name: "Relay Controllers", url: "/boards/relay-controllers", description: "Relay controllers for power management and switching" },
      { name: "Interactive Controllers", url: "/boards/interactive-controllers", description: "Interactive controllers for engaging displays" },
      { name: "Portable Controllers", url: "/boards/portable-controllers", description: "Portable and mobile lighting control solutions" },
      { name: "Power Distribution", url: "/boards/power-distribution", description: "Power distribution and management solutions" },
      { name: "DMX Controllers", url: "/boards/dmx-controllers", description: "DMX controllers for professional lighting control" }
    ]
    
    board_categories.each do |category|
      add_page_to_search(search_data, category[:name], category[:url], category[:description], "boards")
    end
    
    # Add individual boards using I18n data
    board_names = %w[baldrick8 baldrick17 baldrickbadge baldrickdmx baldrickinput1 baldrickinput8 baldricksignals baldrickswitchy]
    
    board_names.each do |board_name|
      begin
        # Get I18n data for this board
        i18n_data = I18n.t("boards.#{board_name}")
        
        # Combine description and features for search content
        description = i18n_data[:description]
        overview_description = i18n_data[:overview][:description]
        features = i18n_data[:overview][:features].join(', ')
        
        # Create comprehensive search content
        content = "#{description} #{overview_description} Features include: #{features}"
        
        # Add additional info if available
        if i18n_data[:overview][:additional_info].present?
          content += " #{i18n_data[:overview][:additional_info]}"
        end
        
        add_page_to_search(search_data, i18n_data[:name], "/boards/#{board_name}", content, "boards", [board_name])
      rescue => e
        puts "Warning: Could not load I18n data for #{board_name}: #{e.message}"
      end
    end
    
    # Add breakthroughs with detailed content
    breakthrough_data = {
      'turnip-network' => {
        name: 'The Turnip Network',
        description: 'Advanced networking capabilities for Baldrick boards. Enables seamless communication and coordination between multiple Baldrick devices for complex lighting installations.',
        features: 'networking, communication, coordination, multiple devices, lighting installations'
      },
      'kluster' => {
        name: 'The Kluster',
        description: 'Cluster management and coordination features for Baldrick boards. Provides centralized control and management of multiple Baldrick devices in a cluster configuration.',
        features: 'cluster management, centralized control, multiple devices, coordination'
      },
      'ce-ukca-certification' => {
        name: 'CE UKCA Certification',
        description: 'Professional certification and compliance for Baldrick boards. Ensures safety standards and regulatory compliance for professional use in various markets.',
        features: 'certification, compliance, safety standards, professional use, regulatory'
      },
      'turniput' => {
        name: 'Turniput',
        description: 'Software integration and control features for Baldrick boards. Provides advanced software tools for programming, configuration, and control of Baldrick devices.',
        features: 'software integration, programming, configuration, control tools, advanced features'
      },
      'hodgical-test-mode' => {
        name: 'Hodgical Test Mode',
        description: 'Advanced testing and diagnostic features for Baldrick boards. Comprehensive testing capabilities for troubleshooting and validating board functionality.',
        features: 'testing, diagnostics, troubleshooting, validation, board functionality'
      },
      'cunningfx' => {
        name: 'CunningFX',
        description: 'Advanced web interface features for Baldrick8. Enhanced user interface with beta software releases, original naming options, and cutting-edge capabilities.',
        features: 'web interface, beta releases, original naming, advanced features, user interface'
      }
    }
    
    breakthrough_data.each do |slug, data|
      content = "#{data[:description]} Features include: #{data[:features]}"
      add_page_to_search(search_data, data[:name], "/breakthroughs/#{slug}", content, "breakthroughs")
    end
    
    # Add support pages with detailed content
    support_pages = {
      'support' => {
        name: 'Support',
        url: '/support',
        description: 'Support and help resources for Baldrick Boards. Comprehensive support documentation, troubleshooting guides, and assistance for all Baldrick products.',
        features: 'support documentation, troubleshooting guides, assistance, help resources'
      },
      'asking-for-help' => {
        name: 'Asking for Help',
        url: '/support/asking-for-help',
        description: 'How to get help with Baldrick boards. Guidelines for requesting support, providing information, and getting the most effective assistance for your Baldrick controller issues.',
        features: 'requesting support, guidelines, assistance, troubleshooting, help process'
      },
      'software' => {
        name: 'Software',
        url: '/support/software',
        description: 'Software downloads and documentation for Baldrick Boards. Latest firmware updates, software tools, configuration utilities, and comprehensive documentation.',
        features: 'software downloads, firmware updates, configuration tools, documentation, utilities'
      }
    }
    
    support_pages.each do |slug, data|
      content = "#{data[:description]} Features include: #{data[:features]}"
      add_page_to_search(search_data, data[:name], data[:url], content, "support")
    end
    
    # Write the search index to a JSON file
    search_index_path = Rails.root.join("public", "search-index.json")
    File.write(search_index_path, JSON.pretty_generate(search_data))
    
    puts "Search index generated with #{search_data.length} pages"
    puts "Index saved to: #{search_index_path}"
    
    # Also create a JavaScript file with the index embedded
    js_content = "window.searchIndex = #{JSON.generate(search_data)};"
    js_path = Rails.root.join("app", "javascript", "search-index.js")
    File.write(js_path, js_content)
    
    # Also create a public version for direct loading
    public_js_path = Rails.root.join("public", "search-index.js")
    File.write(public_js_path, js_content)
    
    puts "JavaScript index saved to: #{js_path}"
  end
end
