namespace :og do
  desc "Audit Open Graph tags across all routes and export to CSV"
  task audit: :environment do
    require 'csv'
    require 'net/http'
    require 'uri'
    
    puts "🔍 Auditing Open Graph tags across all routes..."
    
    # Define all the routes to check
    routes = []
    
    # Main pages
    routes += [
      { path: '/', name: 'Homepage', type: 'page' },
      { path: '/search-test', name: 'Search Test', type: 'page' },
      { path: '/faq', name: 'FAQ', type: 'page' },
      { path: '/where-to-buy-baldrick-boards', name: 'Where to Buy', type: 'page' },
    ]
    
    # About section
    routes += [
      { path: '/about', name: 'About', type: 'about' },
    ]
    
    # Boards section
    routes += [
      { path: '/boards', name: 'Boards Index', type: 'boards' },
    ]
    
    # Board category pages
    routes += [
      { path: '/boards/pixel-controllers', name: 'Pixel Controllers', type: 'board_category' },
      { path: '/boards/relay-controllers', name: 'Relay Controllers', type: 'board_category' },
      { path: '/boards/interactive-controllers', name: 'Interactive Controllers', type: 'board_category' },
      { path: '/boards/portable-controllers', name: 'Portable Controllers', type: 'board_category' },
      { path: '/boards/power-distribution', name: 'Power Distribution', type: 'board_category' },
      { path: '/boards/dmx-controllers', name: 'DMX Controllers', type: 'board_category' },
    ]
    
    # Auto-discover board pages from view directories
    puts "  🔍 Discovering board pages from view directories..."
    board_pages = discover_board_pages
    routes += board_pages
    
    # Baldrick Breakthroughs section
    routes += [
      { path: '/breakthroughs', name: 'Breakthroughs Index', type: 'breakthroughs' },
      { path: '/breakthroughs/turnip-network', name: 'Turnip Network', type: 'breakthrough' },
      { path: '/breakthroughs/kluster', name: 'Kluster', type: 'breakthrough' },
      { path: '/breakthroughs/ce-ukca-certification', name: 'CE UKCA Certification', type: 'breakthrough' },
      { path: '/breakthroughs/turniput', name: 'Turniput', type: 'breakthrough' },
      { path: '/breakthroughs/hodgical-test-mode', name: 'Hodgical Test Mode', type: 'breakthrough' },
      { path: '/breakthroughs/cunningfx', name: 'CunningFX', type: 'breakthrough' },
      { path: '/breakthroughs/busk-board', name: 'Busk Board', type: 'breakthrough' },
    ]
    
    # Fun Stuff section
    routes += [
      { path: '/fun-stuff', name: 'Fun Stuff Index', type: 'fun_stuff' },
      { path: '/fun-stuff/release-notes', name: 'Release Notes', type: 'fun_stuff' },
      { path: '/fun-stuff/stls-and-mounts', name: 'STLs and Mounts', type: 'fun_stuff' },
      { path: '/fun-stuff/board-dimensions', name: 'Board Dimensions', type: 'fun_stuff' },
      { path: '/fun-stuff/faq', name: 'Fun Stuff FAQ', type: 'fun_stuff' },
      { path: '/fun-stuff/problem-solver', name: 'Problem Solver', type: 'fun_stuff' },
      { path: '/fun-stuff/panic-mode', name: 'Panic Mode', type: 'fun_stuff' },
      { path: '/fun-stuff/testimonials', name: 'Testimonials', type: 'fun_stuff' },
      { path: '/fun-stuff/customer-showcase', name: 'Customer Showcase', type: 'fun_stuff' },
    ]
    
    # Support section
    routes += [
      { path: '/support', name: 'Support', type: 'support' },
      { path: '/support/software', name: 'Software Support', type: 'support' },
      { path: '/support/asking-for-help', name: 'Asking for Help', type: 'support' },
    ]
    
    # Prepare CSV data
    csv_data = []
    csv_data << [
      'Route',
      'Name',
      'Type',
      'Status',
      'OG Title',
      'OG Description',
      'OG Image',
      'Twitter Title',
      'Twitter Description',
      'Twitter Image',
      'Page Title',
      'Meta Description'
    ]
    
    # Check each route
    routes.each do |route|
      puts "  📄 Checking #{route[:name]} (#{route[:path]})..."
      
      begin
        # Make request to the route
        uri = URI("http://localhost:3001#{route[:path]}")
        response = Net::HTTP.get_response(uri)
        
        if response.code == '200'
          html = response.body
          
          # Extract Open Graph tags
          og_title = extract_meta_content(html, 'property="og:title"')
          og_description = extract_meta_content(html, 'property="og:description"')
          og_image = extract_meta_content(html, 'property="og:image"')
          
          # Extract Twitter tags
          twitter_title = extract_meta_content(html, 'name="twitter:title"')
          twitter_description = extract_meta_content(html, 'name="twitter:description"')
          twitter_image = extract_meta_content(html, 'name="twitter:image"')
          
          # Extract page title and meta description
          page_title = extract_title(html)
          meta_description = extract_meta_content(html, 'name="description"')
          
          csv_data << [
            route[:path],
            route[:name],
            route[:type],
            '✅ Success',
            og_title,
            og_description,
            og_image,
            twitter_title,
            twitter_description,
            twitter_image,
            page_title,
            meta_description
          ]
          
          puts "    ✅ Success - Title: #{og_title&.truncate(50)}"
        else
          csv_data << [
            route[:path],
            route[:name],
            route[:type],
            "❌ Error #{response.code}",
            '', '', '', '', '', '', '', ''
          ]
          puts "    ❌ Error: #{response.code}"
        end
      rescue => e
        csv_data << [
          route[:path],
          route[:name],
          route[:type],
          "❌ Exception: #{e.message}",
          '', '', '', '', '', '', '', ''
        ]
        puts "    ❌ Exception: #{e.message}"
      end
    end
    
    # Write CSV file
    filename = "open_graph_audit_#{Date.current.strftime('%Y%m%d_%H%M%S')}.csv"
    filepath = Rails.root.join(filename)
    
    CSV.open(filepath, 'w') do |csv|
      csv_data.each { |row| csv << row }
    end
    
    puts "\n📊 Open Graph audit complete!"
    puts "📁 Results saved to: #{filename}"
    puts "📈 Total routes checked: #{routes.length}"
    puts "✅ Successful: #{csv_data.count { |row| row[3] == '✅ Success' }}"
    puts "❌ Failed: #{csv_data.count { |row| row[3].start_with?('❌') }}"
    puts "\n💡 Next steps:"
    puts "   1. Open the CSV file to review the data"
    puts "   2. Identify missing or incorrect Open Graph data"
    puts "   3. Update I18n files or create missing images"
    puts "   4. Re-run this audit to verify improvements"
  end
  
  private
  
  def discover_board_pages
    board_pages = []
    boards_dir = Rails.root.join('app', 'views', 'boards')
    
    # Get all board directories
    board_dirs = Dir.glob(boards_dir.join('*')).select { |d| File.directory?(d) }
    
    board_dirs.each do |board_dir|
      board_name = File.basename(board_dir)
      
      # Get all HTML files in the board directory
      html_files = Dir.glob(File.join(board_dir, '*.html.slim'))
      
      html_files.each do |html_file|
        page_name = File.basename(html_file, '.html.slim')
        
        # Skip shared files
        next if page_name.start_with?('_')
        
        # Convert underscore to hyphen for URL
        url_page_name = page_name.gsub('_', '-')
        
        # Determine page type and name
        case page_name
        when 'overview'
          type = 'board'
          name = "#{board_name.capitalize} Overview"
        when 'faq'
          type = 'board_faq'
          name = "#{board_name.capitalize} FAQ"
        when 'web_interface'
          type = 'board_web'
          name = "#{board_name.capitalize} Web Interface"
        when 'buy_this_board'
          type = 'board_buy'
          name = "#{board_name.capitalize} Buy This Board"
        when 'getting_started'
          type = 'board_getting_started'
          name = "#{board_name.capitalize} Getting Started"
        when 'tech_specs'
          type = 'board_tech_specs'
          name = "#{board_name.capitalize} Tech Specs"
        else
          type = 'board_other'
          name = "#{board_name.capitalize} #{page_name.humanize}"
        end
        
        # Add to routes
        if page_name == 'overview'
          # Overview page is at /boards/boardname
          board_pages << { path: "/boards/#{board_name}", name: name, type: type }
        else
          # Other pages are at /boards/boardname/page-name
          board_pages << { path: "/boards/#{board_name}/#{url_page_name}", name: name, type: type }
        end
      end
    end
    
    puts "    📋 Found #{board_pages.length} board pages"
    board_pages
  end
  
  def extract_meta_content(html, attribute)
    # Handle both property and name attributes, and account for minified HTML
    # Try both orders: content="..." property="..." and property="..." content="..."
    regex1 = /<meta[^>]*content="([^"]*)"[^>]*#{Regexp.escape(attribute)}[^>]*>/i
    regex2 = /<meta[^>]*#{Regexp.escape(attribute)}[^>]*content="([^"]*)"[^>]*>/i
    
    match = html.match(regex1) || html.match(regex2)
    match ? match[1] : nil
  end
  
  def extract_title(html)
    regex = /<title[^>]*>([^<]*)<\/title>/i
    match = html.match(regex)
    match ? match[1] : nil
  end
end
