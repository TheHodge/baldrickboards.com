class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml { render xml: generate_sitemap }
    end
  end

  private

  def generate_sitemap
    # Check both possible locations for the sitemap
    sitemap_paths = [
      Rails.root.join('public', 'sitemap.xml'),
      Rails.root.join('public', 'sitemaps', 'sitemap.xml')
    ]
    
    sitemap_path = sitemap_paths.find { |path| path.exist? && path.mtime > 24.hours.ago }
    
    if sitemap_path
      # Serve existing sitemap
      File.read(sitemap_path)
    else
      # Generate new sitemap
      generate_fresh_sitemap
    end
  end

  def generate_fresh_sitemap
    # This will generate the sitemap and return the XML content
    require 'sitemap_generator'
    
    # Temporarily redirect output to capture XML
    original_stdout = $stdout
    $stdout = StringIO.new
    
    begin
      # Load and execute the sitemap configuration
      load Rails.root.join('config', 'sitemap.rb')
      
      # Get the generated XML content from either location
      sitemap_paths = [
        Rails.root.join('public', 'sitemap.xml'),
        Rails.root.join('public', 'sitemaps', 'sitemap.xml')
      ]
      
      sitemap_file = sitemap_paths.find { |path| path.exist? }
      if sitemap_file
        File.read(sitemap_file)
      else
        # Fallback: generate a basic sitemap
        generate_basic_sitemap
      end
    ensure
      $stdout = original_stdout
    end
  end

  def generate_basic_sitemap
    # Fallback sitemap generation if the main one fails
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        # Add basic pages
        locales = [:en, :es, :fr, :de]
        locales.each do |locale|
          xml.url do
            xml.loc "https://www.baldrickboard.com/#{locale == :en ? '' : locale}/"
            xml.changefreq 'weekly'
            xml.priority '1.0'
          end
        end
      end
    end
    
    builder.to_xml
  end
end
