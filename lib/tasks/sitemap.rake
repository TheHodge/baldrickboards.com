namespace :sitemap do
  desc "Generate sitemap"
  task generate: :environment do
    Rails.logger.info "Generating sitemap..."
    puts "Generating sitemap..."
    
    begin
      # Load the sitemap configuration
      load Rails.root.join('config', 'sitemap.rb')
      
      # Check both possible locations for the sitemap
      sitemap_paths = [
        Rails.root.join('public', 'sitemap.xml'),
        Rails.root.join('public', 'sitemaps', 'sitemap.xml')
      ]
      
      sitemap_path = sitemap_paths.find { |path| File.exist?(path) }
      
      if sitemap_path
        file_size = File.size(sitemap_path)
        Rails.logger.info "Sitemap generated successfully! Size: #{file_size} bytes"
        puts "Sitemap generated successfully! Size: #{file_size} bytes"
        puts "Location: #{sitemap_path}"
      else
        Rails.logger.error "Sitemap generation failed - file not created"
        puts "Error: Sitemap file was not created"
        puts "Checked locations: #{sitemap_paths.map(&:to_s).join(', ')}"
      end
    rescue => e
      Rails.logger.error "Sitemap generation failed: #{e.message}"
      puts "Error generating sitemap: #{e.message}"
      raise e
    end
  end

  desc "Generate and ping search engines"
  task ping: :environment do
    Rails.logger.info "Generating sitemap and pinging search engines..."
    puts "Generating sitemap and pinging search engines..."
    
    begin
      # Generate the sitemap first
      Rake::Task['sitemap:generate'].invoke
      
      # Ping search engines
      SitemapGenerator::Sitemap.ping_search_engines
      Rails.logger.info "Successfully pinged search engines!"
      puts "Successfully pinged search engines!"
    rescue => e
      Rails.logger.error "Error pinging search engines: #{e.message}"
      puts "Error pinging search engines: #{e.message}"
      # Don't raise here - sitemap generation might have succeeded
    end
  end

  desc "Clean old sitemap files"
  task clean: :environment do
    Rails.logger.info "Cleaning old sitemap files..."
    puts "Cleaning old sitemap files..."
    
    cleaned_count = 0
    
    sitemap_dir = Rails.root.join('public', 'sitemaps')
    if Dir.exist?(sitemap_dir)
      # Remove files older than 7 days
      Dir.glob(File.join(sitemap_dir, '*')).each do |file|
        if File.mtime(file) < 7.days.ago
          File.delete(file)
          cleaned_count += 1
          Rails.logger.info "Deleted old sitemap file: #{file}"
          puts "Deleted: #{file}"
        end
      end
    end
    
    Rails.logger.info "Cleanup completed! Removed #{cleaned_count} files"
    puts "Cleanup completed! Removed #{cleaned_count} files"
  end

  desc "Check sitemap status"
  task status: :environment do
    sitemap_paths = [
      Rails.root.join('public', 'sitemap.xml'),
      Rails.root.join('public', 'sitemaps', 'sitemap.xml')
    ]
    
    sitemap_path = sitemap_paths.find { |path| File.exist?(path) }
    
    if sitemap_path
      file_size = File.size(sitemap_path)
      last_modified = File.mtime(sitemap_path)
      age = Time.current - last_modified
      
      puts "Sitemap Status:"
      puts "  File exists: Yes"
      puts "  Size: #{file_size} bytes"
      puts "  Last modified: #{last_modified}"
      puts "  Age: #{age.to_i / 3600} hours"
      puts "  Location: #{sitemap_path}"
    else
      puts "Sitemap Status:"
      puts "  File exists: No"
      puts "  Checked locations: #{sitemap_paths.map(&:to_s).join(', ')}"
      puts "  Run 'rake sitemap:generate' to create it"
    end
  end
end
