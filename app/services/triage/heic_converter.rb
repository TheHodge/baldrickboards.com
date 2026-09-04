require "open3"

module Triage
  class HeicConverter
    HEIC_CONTENT_TYPES = %w[
      image/heic
      image/heif
      image/heic-sequence
      image/heif-sequence
    ].freeze

    HEIC_EXTENSIONS = %w[.heic .heif .heics .heifs].freeze

    def self.convert(uploaded_file)
      new(uploaded_file).convert
    end

    def initialize(uploaded_file)
      @file = uploaded_file
    end

    def convert
      return @file unless heic?

      jpeg = convert_to_jpeg
      return @file unless jpeg

      ActionDispatch::Http::UploadedFile.new(
        filename: jpeg_filename,
        type: "image/jpeg",
        tempfile: jpeg
      )
    rescue StandardError => e
      Rails.logger.warn("[Triage::HeicConverter] #{e.class}: #{e.message}")
      @file
    end

    def heic?
      content_type = @file.content_type.to_s.downcase
      return true if HEIC_CONTENT_TYPES.include?(content_type)

      HEIC_EXTENSIONS.include?(File.extname(original_filename).downcase)
    end

    private

    def original_filename
      @file.original_filename.to_s
    end

    def jpeg_filename
      "#{File.basename(original_filename, '.*')}.jpg"
    end

    def source_path
      @file.tempfile.path
    end

    def convert_to_jpeg
      dest = Tempfile.new([File.basename(original_filename, ".*"), ".jpg"])
      dest.binmode
      sanitized = nil

      if convert_path(source_path, dest.path)
        dest.rewind
        return dest
      end

      sanitized = HeicIrefSanitizer.sanitize_to_tempfile(source_path)
      if sanitized && convert_path(sanitized, dest.path)
        dest.rewind
        dest
      else
        dest.close!
        nil
      end
    ensure
      File.delete(sanitized) if sanitized && File.exist?(sanitized)
    end

    def convert_path(path, dest_path)
      convert_with_mini_magick(path, dest_path) || convert_with_heif_convert(path, dest_path)
    end

    def convert_with_mini_magick(path, dest_path)
      image = MiniMagick::Image.open("#{path}[0]")
      image.format("jpg")
      image.write(dest_path)
      File.size?(dest_path).to_i.positive?
    rescue MiniMagick::Error, MiniMagick::Invalid => e
      Rails.logger.info("[Triage::HeicConverter] MiniMagick could not convert HEIC: #{e.message}")
      false
    end

    def convert_with_heif_convert(path, dest_path)
      _stdout, stderr, status = Open3.capture3("heif-convert", path, dest_path)
      return true if status.success? && File.size?(dest_path).to_i.positive?

      Rails.logger.info("[Triage::HeicConverter] heif-convert failed: #{stderr.presence || status}")
      false
    rescue Errno::ENOENT
      Rails.logger.info("[Triage::HeicConverter] heif-convert is not installed")
      false
    end
  end
end
