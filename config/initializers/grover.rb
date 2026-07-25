# frozen_string_literal: true

require "grover"

Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: {
      top: "14mm",
      bottom: "16mm",
      left: "12mm",
      right: "12mm"
    },
    print_background: true,
    prefer_css_page_size: true,
    emulate_media: "print",
    timeout: 60_000,
    launch_args: %w[
      --no-sandbox
      --disable-setuid-sandbox
      --font-render-hinting=medium
      --disable-dev-shm-usage
    ],
    wait_until: "networkidle0"
  }

  # Production (Hatchbox/Docker): point at system Chromium.
  # Locally, Grover uses Puppeteer's bundled Chrome from node_modules.
  executable = ENV["GROVER_EXECUTABLE_PATH"].presence || ENV["PUPPETEER_EXECUTABLE_PATH"].presence
  config.options[:executable_path] = executable if executable
end
