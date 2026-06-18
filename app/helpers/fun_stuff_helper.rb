module FunStuffHelper
  FUN_STUFF_PAGES = [
    {
      id: 'release_notes',
      path: :fun_stuff_release_notes_path,
      title: 'Release Notes',
      tag: 'Firmware updates',
      image: 'firmware3pointoh.png',
      description: 'Stay up to date with the latest firmware releases, new features and the changelog for every Baldrick board.',
      bullets: ['Current version matrix', 'Full release history', 'Special boot modes', 'Update tips']
    },
    {
      id: 'stls_and_mounts',
      path: :fun_stuff_stls_and_mounts_path,
      title: 'STLs & Mounts',
      tag: '3D printing',
      image: 'stl-greg.png',
      description: 'Community-designed mounts and enclosures you can print today — Meanwell stacks, Pi holders and more.',
      bullets: ['Downloadable STLs', 'Community designs', 'Power supply mounts', 'Share your own']
    },
    {
      id: 'board_dimensions',
      path: :fun_stuff_board_dimensions_path,
      title: 'Board Dimensions',
      tag: 'Technical specs',
      image: 'dimensions-medium.jpeg',
      description: 'Small, medium and large form factors — footprints, mounting holes and which boards share each size.',
      bullets: ['Three size classes', 'M3 mounting holes', 'Compatibility chart', 'Mounting guidance']
    },
    {
      id: 'panic_mode',
      path: :fun_stuff_panic_mode_path,
      title: 'Panic Mode',
      tag: 'Holiday countdown',
      image: nil,
      icon: 'panic',
      description: 'Should you be panicking about your holiday display? DEFCON-style gauges for Halloween and Christmas show prep.',
      bullets: ['Halloween countdown', 'Christmas countdown', 'DEFCON threat levels', 'Purely for fun']
    },
    {
      id: 'testimonials',
      path: :fun_stuff_testimonials_path,
      title: 'Testimonials',
      tag: 'Customer stories',
      image: nil,
      icon: 'quote',
      description: 'Real feedback from display builders who put Baldrick boards through a season (or three).',
      bullets: ['Community voices', 'Honest reviews', 'Share your story', 'Join the group']
    },
    {
      id: 'customer_showcase',
      path: :fun_stuff_customer_showcase_path,
      title: 'Customer Showcase',
      tag: 'Amazing displays',
      image: 'showcase/float.jpg',
      description: 'Incredible installs from talented customers — floats, facades, trees and everything in between.',
      bullets: ['Photo gallery', 'Real-world installs', 'Get featured', 'Submit your show']
    },
    {
      id: 'faq',
      path: :fun_stuff_faq_path,
      title: 'FAQ',
      tag: 'Common questions',
      image: nil,
      icon: 'faq',
      description: 'General questions about Baldrick products, setup, troubleshooting and compatibility.',
      bullets: ['Setup help', 'Troubleshooting', 'Compatibility', 'Warranty & support']
    }
  ].freeze

  def fun_stuff_pages
    FUN_STUFF_PAGES
  end

  def fun_stuff_card(page)
    link_to public_send(page[:path]), class: 'pcard' do
      safe_join([
        content_tag(:div, class: 'shot') do
          if page[:image].present?
            image_tag(page[:image], alt: page[:title])
          else
            content_tag(:div, class: "shot-icon shot-icon--#{page[:icon]}") do
              fun_stuff_card_icon(page[:icon])
            end
          end
        end,
        content_tag(:div, class: 'pcard-body') do
          safe_join([
            content_tag(:h3, page[:title]),
            content_tag(:span, page[:tag], class: 'spec'),
            content_tag(:p, page[:description]),
            content_tag(:ul, class: 'pcard-bullets') do
              safe_join(page[:bullets].map { |item| content_tag(:li, item) })
            end,
            content_tag(:span, class: 'btn btn-solid btn-sm') do
              safe_join(['Read more ', content_tag(:span, '→', class: 'ar')])
            end
          ])
        end
      ])
    end
  end

  def fun_stuff_faq_sections
    [
      {
        id: 'general',
        title: 'General questions',
        items: [
          { question: 'What makes Baldrick boards different from other controllers?', answer: 'Baldrick boards are designed with simplicity and reliability in mind. We focus on ease of use, robust construction, and excellent support. Our boards feature intuitive web interfaces, comprehensive protocol support, and are built with high-quality components for long-term reliability.' },
          { question: 'Do I need a Raspberry Pi or FPP license?', answer: 'No! Baldrick boards are standalone controllers that don\'t require a Raspberry Pi or any additional licenses. They run their own firmware and web interface, making setup simple and cost-effective.' },
          { question: 'What LED protocols are supported?', answer: 'Baldrick boards support all major LED protocols including WS2811, WS2812B, SK6812, APA102, and many others. Check the specific board\'s technical specifications for the complete list of supported protocols.' },
          { question: 'Can I use Baldrick boards outdoors?', answer: 'Yes, but you\'ll need to provide proper protection. While our boards are built with quality components, they should be mounted in weatherproof enclosures for outdoor use. We offer 3D printable enclosure designs and recommend using appropriate materials for your environment.' }
        ]
      },
      {
        id: 'setup',
        title: 'Setup & configuration',
        items: [
          { question: 'How do I access the web interface?', answer: 'When you first power on your Baldrick board, it creates a WiFi access point named "Baldrick8-XXXX" (or similar). Connect to this network (no password required) and navigate to 192.168.4.1 in your web browser. You can then configure your network settings and board parameters.' },
          { question: 'What power supply do I need?', answer: 'Baldrick boards accept 5V–24V DC power. The exact voltage depends on your LED strip requirements. For 5V LED strips, use a 5V power supply. For 12V LED strips, use a 12V power supply. Choose a power supply with sufficient current capacity for your total LED count.' },
          { question: 'How many pixels can I connect to each output?', answer: 'Each output can handle up to 750 RGB pixels at 40fps. For optimal performance, we recommend keeping each output under 500 pixels. The exact number depends on your refresh rate requirements and LED protocol.' },
          { question: 'Can I use different voltages on the two power inputs?', answer: 'Yes! Baldrick boards have two power inputs that can accept different voltages. This allows you to power different sections of your display with different voltages if needed, providing maximum flexibility for your setup.' }
        ]
      },
      {
        id: 'troubleshooting',
        title: 'Troubleshooting',
        items: [
          { question: 'My LEDs aren\'t working. What should I check?', answer: 'First, verify your power supply is adequate for your LED count. Check that your data direction is correct — LEDs won\'t work if connected backwards. Ensure your pixel count and protocol settings match your LED strips. Use the test patterns in the web interface to verify basic functionality.' },
          { question: 'I can\'t connect to the web interface. What\'s wrong?', answer: 'Make sure you\'re connecting to the correct WiFi network (Baldrick8-XXXX or similar). Try accessing 192.168.4.1 in your browser. If that doesn\'t work, try 192.168.1.100 or check your network settings.' },
          { question: 'The board is getting hot. Is this normal?', answer: 'Some warmth is normal during operation, especially when driving many LEDs. However, if the board becomes uncomfortably hot, check your power supply capacity and ensure adequate ventilation.' },
          { question: 'How do I update the firmware?', answer: 'Firmware updates are available through the web interface. Navigate to the System section and follow the update instructions. Always backup your configuration before updating.' }
        ]
      },
      {
        id: 'compatibility',
        title: 'Compatibility & integration',
        items: [
          { question: 'Can I use Baldrick boards with xLights?', answer: 'Yes! Baldrick boards have direct xLights integration. You can push sequences directly from xLights to the controller without needing additional software.' },
          { question: 'What network protocols are supported?', answer: 'Baldrick boards support DDP, Artnet, E1.31, and sACN protocols, making them compatible with most professional lighting software.' },
          { question: 'Can I use multiple Baldrick boards together?', answer: 'Absolutely! Multiple Baldrick boards can work together on the same network via the Turnip Network, each handling different sections of your display.' },
          { question: 'Do the button inputs work with FPP?', answer: 'Yes! The button inputs can execute URLs when pressed, which can be used with the FPP API to start/stop sequences or trigger other actions.' }
        ]
      },
      {
        id: 'warranty',
        title: 'Warranty & support',
        items: [
          { question: 'What\'s the warranty period?', answer: 'Baldrick boards come with a standard warranty. Check your purchase documentation for specific warranty terms and conditions.' },
          { question: 'Can I drill out the mounting holes to fit different screws?', answer: '<strong>No!</strong> DO NOT drill out the mounting holes. This will void your warranty. Use the correct M3 hardware as specified in the documentation.' },
          { question: 'How do I get technical support?', answer: 'Check our support page, join our Facebook group for community help, or use our hardware support form for technical issues.' },
          { question: 'Can I use Baldrick boards for commercial installations?', answer: 'Yes! Baldrick boards are designed for professional use and include CE and UKCA certification for European and UK markets.' }
        ]
      }
    ]
  end

  def fun_stuff_faq_toc
    fun_stuff_faq_sections.map do |section|
      {
        id: section[:id],
        title: section[:title],
        items: section[:items].map.with_index { |item, i| { id: "#{section[:id]}-#{i}", title: item[:question].truncate(42) } }
      }
    end
  end

  def stls_and_mounts_toc
    [
      {
        id: 'downloads',
        title: 'Downloads',
        items: [
          { id: 'greg-mount', title: 'Original Baldrick Mount' },
          { id: 'pi-buck-mount', title: 'Pi + Buck Converter Mount' },
          { id: 'double-stack', title: 'Double Stack Meanwell Mounts' },
          { id: 'b17-mount', title: 'Baldrick17 Mount' }
        ]
      },
      { id: 'share-yours', title: 'Share yours', items: [] }
    ]
  end

  def board_dimensions_toc
    [
      { id: 'small', title: 'Small boards', items: [] },
      { id: 'medium', title: 'Medium boards', items: [] },
      { id: 'large', title: 'Large boards', items: [] },
      { id: 'compatibility', title: 'Board compatibility', items: [] }
    ]
  end

  def release_notes_toc
    path = Rails.root.join('app/views/fun_stuff/_release_notes_content.html.slim')
    items = []
    if path.exist?
      path.read.scan(/\.rn-entry#([\w-]+)\n(.*?)(?=\n\s*\.rn-entry#|\z)/m) do |id, body|
        title = body[/\bh4(?:\.[^\n]+)?\s+(.+)/, 1]&.strip
        items << { id: id, title: title } if title.present?
      end
    end
    [
      { id: 'release-history', title: 'Releases', items: items },
      { id: 'support', title: 'Support', items: [] }
    ]
  end

  private

  def fun_stuff_card_icon(kind)
    svg = case kind
          when 'panic'
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z"/><path d="M12 9v4M12 17h.01"/></svg>'
          when 'quote'
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M7 8h10M7 12h6M6 20l2-6H4l2-6h6l-2 6z"/></svg>'
          when 'faq'
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><circle cx="12" cy="12" r="10"/><path d="M9.5 9.5a2.5 2.5 0 1 1 4.2 1.8c-.8.7-1.7 1.2-1.7 2.7M12 17h.01"/></svg>'
          else
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9"><path d="M12 2l3 7h7l-5.5 4.5L18 21l-6-4-6 4 1.5-7.5L2 9h7z"/></svg>'
          end
    svg.html_safe
  end
end
