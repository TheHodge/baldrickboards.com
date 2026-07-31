module BreakthroughsHelper
  BREAKTHROUGH_PAGES = [
    {
      id: 'turnip_network',
      path: :breakthroughs_turnip_network_path,
      title: 'The Turnip Network',
      tag: 'Network innovation',
      image: 'baldrick8/web-interface-turnip-network.png',
      description: 'Board-to-board networking that lets your show talk to itself — discoverability, test sync and FPP integration without writing code.',
      bullets: ['Board discoverability', 'Test sync across props', 'FPP auto-detection', 'More features incoming']
    },
    {
      id: 'kluster',
      path: :breakthroughs_kluster_path,
      title: 'The Kluster',
      tag: 'Development lab',
      image: 'kluster-two.png',
      description: 'Our in-house test rig where every Baldrick board gets hammered before it ships — from plywood prototype to laser-cut monitoring wall.',
      bullets: ['Every board variant', 'Remote test control', 'Pixel monitoring', 'Continuous validation']
    },
    {
      id: 'ce_ukca_certification',
      path: :breakthroughs_ce_ukca_certification_path,
      title: 'CE & UKCA Certification',
      tag: 'Compliance & safety',
      image: 'ce-ukca-rohs.png',
      description: 'Independent lab testing, RoHS-compliant components and formal CE and UKCA marks — because budget never meant cutting corners.',
      bullets: ['CE & UKCA certified', 'RoHS compliant', 'Technical file on file', 'Professional reliability']
    },
    {
      id: 'turniput',
      path: :breakthroughs_turniput_path,
      title: 'Turniput',
      tag: 'Show interactivity',
      image: 'baldrickinput8/web-interface-turnip-config.png',
      description: 'Physical inputs that trigger effects across your network — buttons, sensors and lamp control, all point-and-click.',
      bullets: ['Buttons & sensors', 'Lamp control', 'FPP integration', 'Webhook triggers']
    },
    {
      id: 'hodgical_test_mode',
      path: :breakthroughs_hodgical_test_mode_path,
      title: 'Hodgical Test Mode',
      tag: 'Debugging',
      image: 'hodgical-header.png',
      description: 'A Baldrick8 test mode that cycles RGB across models on a port so you can spot dodgy pixels and wiring in seconds.',
      bullets: ['Per-model RGB offset', 'Quick pixel checks', 'Model verification', 'Visitor demo mode']
    },
    {
      id: 'cunningfx',
      path: :breakthroughs_cunningfx_path,
      title: 'CunningFX',
      tag: 'Effects engine',
      image: 'cunningfx.png',
      description: 'Built-in effects and presets in the web interface — rainbow, twinkle, bounce and more, no show player required.',
      bullets: ['Layered presets', 'Per-port effects', 'Real-time control', 'Turnip Network triggers']
    },
    {
      id: 'busk_board',
      path: :breakthroughs_busk_board_path,
      title: 'Busk Board',
      tag: 'Live control',
      image: 'big-red-button.png',
      description: 'Trigger CunningFX and DMX presets from big buttons on your phone or tablet — busk your show without a laptop.',
      bullets: ['Mobile & tablet ready', 'CunningFX triggers', 'DMX preset control', 'One-tap busking']
    }
  ].freeze

  def breakthrough_pages
    BREAKTHROUGH_PAGES
  end

  def turniput_toc
    [
      { id: 'what-is-turniput', title: 'What is a Turniput', items: [] },
      { id: 'input-types', title: 'Input types', items: [] },
      { id: 'lamp-control', title: 'Lamp control', items: [] },
      {
        id: 'fpp-integration',
        title: 'Integrations',
        items: [
          { id: 'fpp-integration', title: 'FPP integration' },
          { id: 'webhook-integration', title: 'Webhook integration' }
        ]
      }
    ]
  end

  def cunningfx_toc
    [
      { id: 'introduction', title: 'Introduction', items: [] },
      { id: 'presets', title: 'Presets', items: [] },
      {
        id: 'effects',
        title: 'Effects',
        items: [
          { id: 'colour-splash', title: 'Colour Splash' },
          { id: 'rainbow', title: 'Rainbow' },
          { id: 'twinkle', title: 'Twinkle' },
          { id: 'bounce', title: 'Bounce' },
          { id: 'alternate', title: 'Alternate' },
          { id: 'fader', title: 'Fader' },
          { id: 'on-off', title: 'On / Off' }
        ]
      },
      { id: 'turnip-network', title: 'Turnip Network', items: [] }
    ]
  end

  def busk_board_toc
    [
      { id: 'what-is-busk-board', title: 'What is Busk Board', items: [] },
      { id: 'how-it-works', title: 'How it works', items: [] },
      { id: 'inspiration', title: 'Inspiration', items: [] }
    ]
  end

  def breakthrough_card(page)
    link_to public_send(page[:path]), class: 'pcard' do
      safe_join([
        content_tag(:div, class: 'shot') do
          image_tag(page[:image], alt: page[:title])
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
end
