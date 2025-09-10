# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.baldrickboard.com"

# Pick a place safe to write the files (Hatchbox handles this automatically)
SitemapGenerator::Sitemap.public_path = 'public/'

# Store on S3 using aws-sdk gem (optional for Hatchbox)
# Uncomment and configure if you want to store sitemaps on S3
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
#   'my-bucket',
#   aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#   aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#   aws_region: 'us-east-1'
# )

# Inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "https://www.baldrickboard.com/"

# Pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

# Hatchbox-specific configuration
# Ensure proper file permissions and logging
SitemapGenerator::Sitemap.verbose = Rails.env.production?

# Create uncompressed sitemap in public root for easy access
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  # Available locales - configure based on environment or feature flag
  # Set ENV['SITEMAP_ALL_LOCALES']=true to include all locales
  if ENV['SITEMAP_ALL_LOCALES'] == 'true'
    locales = [:en, :es, :fr, :de]
  else
    locales = [:en]  # Only English for now
  end
  
  # Static pages for each locale
  locales.each do |locale|
    locale_prefix = locale == :en ? '/en' : "/#{locale}"
    
    # Home page
    add "#{locale_prefix}/", changefreq: 'weekly', priority: 1.0
    
    # About page
    add "#{locale_prefix}/about", changefreq: 'monthly', priority: 0.8
    
    # Boards index
    add "#{locale_prefix}/boards", changefreq: 'weekly', priority: 0.9
    
    # Board categories
    add "#{locale_prefix}/boards/pixel-controllers", changefreq: 'weekly', priority: 0.8
    add "#{locale_prefix}/boards/relay-controllers", changefreq: 'weekly', priority: 0.8
    add "#{locale_prefix}/boards/interactive-controllers", changefreq: 'weekly', priority: 0.8
    add "#{locale_prefix}/boards/portable-controllers", changefreq: 'weekly', priority: 0.8
    add "#{locale_prefix}/boards/dmx-controllers", changefreq: 'weekly', priority: 0.8
    
    # Individual board pages (you'll need to define these based on your board data)
    board_names = %w[
      baldrick8 baldrick17 baldrickdmx baldrickinput1 baldrickinput8 
      baldricksignals baldrickswitchy baldrickbadge baldrickbuck
    ]
    
    board_names.each do |board|
      add "#{locale_prefix}/boards/#{board}", changefreq: 'weekly', priority: 0.8
      
      # Board sub-pages
      board_pages = %w[overview getting_started tech_specs web_interface buy_this_board]
      board_pages.each do |page|
        add "#{locale_prefix}/boards/#{board}/#{page}", changefreq: 'monthly', priority: 0.7
      end
    end
    
    # Breakthroughs
    add "#{locale_prefix}/breakthroughs", changefreq: 'weekly', priority: 0.8
    add "#{locale_prefix}/breakthroughs/turnip-network", changefreq: 'monthly', priority: 0.7
    add "#{locale_prefix}/breakthroughs/kluster", changefreq: 'monthly', priority: 0.7
    add "#{locale_prefix}/breakthroughs/ce-ukca-certification", changefreq: 'monthly', priority: 0.7
    add "#{locale_prefix}/breakthroughs/turniput", changefreq: 'monthly', priority: 0.7
    add "#{locale_prefix}/breakthroughs/hodgical-test-mode", changefreq: 'monthly', priority: 0.7
    add "#{locale_prefix}/breakthroughs/cunningfx", changefreq: 'monthly', priority: 0.7
    
    # Fun Stuff
    add "#{locale_prefix}/fun-stuff", changefreq: 'weekly', priority: 0.6
    add "#{locale_prefix}/fun-stuff/release-notes", changefreq: 'weekly', priority: 0.6
    add "#{locale_prefix}/fun-stuff/stls-and-mounts", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/fun-stuff/board-dimensions", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/fun-stuff/faq", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/fun-stuff/problem-solver", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/fun-stuff/panic-mode", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/fun-stuff/testimonials", changefreq: 'weekly', priority: 0.6
    add "#{locale_prefix}/fun-stuff/customer-showcase", changefreq: 'weekly', priority: 0.6
    
    # Support
    add "#{locale_prefix}/support", changefreq: 'monthly', priority: 0.6
    add "#{locale_prefix}/support/software", changefreq: 'monthly', priority: 0.5
    add "#{locale_prefix}/support/asking-for-help", changefreq: 'monthly', priority: 0.5
    
    # FAQ
    add "#{locale_prefix}/faq", changefreq: 'monthly', priority: 0.6
    
    # Where to buy
    add "#{locale_prefix}/where-to-buy-baldrick-boards", changefreq: 'monthly', priority: 0.7
  end
  
  # Add any dynamic content here
  # For example, if you have blog posts or news articles:
  # Post.find_each do |post|
  #   add post_path(post), lastmod: post.updated_at
  # end
end
