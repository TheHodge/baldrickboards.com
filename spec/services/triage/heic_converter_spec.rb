require "rails_helper"

RSpec.describe Triage::HeicConverter do
  def uploaded_file(filename:, content_type:, content: "heic-bytes")
    tempfile = Tempfile.new([File.basename(filename, ".*"), File.extname(filename)])
    tempfile.binmode
    tempfile.write(content)
    tempfile.rewind
    ActionDispatch::Http::UploadedFile.new(
      filename: filename,
      type: content_type,
      tempfile: tempfile
    )
  end

  describe "#heic?" do
    it "detects HEIC by content type" do
      file = uploaded_file(filename: "photo.jpg", content_type: "image/heic")
      expect(described_class.new(file).heic?).to be true
    end

    it "detects HEIC by filename when the browser sends an empty type" do
      file = uploaded_file(filename: "IMG_1234.HEIC", content_type: "application/octet-stream")
      expect(described_class.new(file).heic?).to be true
    end

    it "leaves JPEG files alone" do
      file = uploaded_file(filename: "photo.jpg", content_type: "image/jpeg", content: "jpeg")
      expect(described_class.new(file).heic?).to be false
      expect(described_class.convert(file)).to eq(file)
    end
  end

  describe ".convert" do
    it "returns the original file when conversion tools fail" do
      file = uploaded_file(filename: "photo.heic", content_type: "image/heic")
      allow(MiniMagick::Image).to receive(:open).and_raise(MiniMagick::Error, "no HEIC delegate")
      allow(Open3).to receive(:capture3).and_raise(Errno::ENOENT)

      result = described_class.convert(file)
      expect(result.original_filename).to eq("photo.heic")
    end

    it "returns a JPEG uploaded file when MiniMagick conversion succeeds" do
      file = uploaded_file(filename: "photo.heic", content_type: "image/heic")
      image = instance_double(MiniMagick::Image)
      allow(MiniMagick::Image).to receive(:open).and_return(image)
      allow(image).to receive(:format)
      allow(image).to receive(:write) do |path|
        File.binwrite(path, "jpeg-bytes")
      end

      result = described_class.convert(file)
      expect(result.original_filename).to eq("photo.jpg")
      expect(result.content_type).to eq("image/jpeg")
      expect(result.read).to eq("jpeg-bytes")
    end

    it "retries conversion after retargeting iOS 18 tmap auxiliary refs" do
      file = uploaded_file(filename: "photo.heic", content_type: "image/heic")
      sanitized = Tempfile.new(["sanitized", ".heic"])
      sanitized.write("sanitized-heic")
      sanitized.flush

      image = instance_double(MiniMagick::Image)
      allow(MiniMagick::Image).to receive(:open) do |path|
        raise MiniMagick::Error, "Non-existing depth image referenced" unless path.include?("sanitized")

        image
      end
      allow(image).to receive(:format)
      allow(image).to receive(:write) { |path| File.binwrite(path, "jpeg-bytes") }
      status = instance_double(Process::Status, success?: false)
      allow(Open3).to receive(:capture3).and_return(["", "depth", status])
      allow(Triage::HeicIrefSanitizer).to receive(:sanitize_to_tempfile).and_return(sanitized.path)

      result = described_class.convert(file)
      expect(result.original_filename).to eq("photo.jpg")
      expect(result.read).to eq("jpeg-bytes")
    ensure
      sanitized.close!
    end
  end
end
