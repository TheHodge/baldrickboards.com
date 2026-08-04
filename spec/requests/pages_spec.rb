require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "redirects to default locale" do
      get root_path
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to("/en")
    end

    it "loads home page with locale" do
      get root_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick Boards")
    end
  end

  describe "GET /en/boards" do
    it "loads boards index page" do
      get boards_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick Boards")
    end
  end

  describe "GET /en/boards/baldrick8" do
    it "loads Baldrick8 overview page" do
      get board_path('baldrick8', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick8")
    end
  end

  describe "GET /en/boards/baldrick8/overview" do
    it "loads Baldrick8 overview page" do
      get board_page_path('baldrick8', 'overview', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick8")
    end
  end

  describe "GET /en/boards/baldrick8/getting-started" do
    it "loads Baldrick8 getting started page" do
      get board_page_path('baldrick8', 'getting-started', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Getting Started")
    end
  end

  describe "GET /en/boards/baldrick8/tech-specs" do
    it "loads Baldrick8 tech specs page" do
      get board_page_path('baldrick8', 'tech-specs', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Technical Specifications")
    end
  end

  describe "GET /en/boards/baldrick8/web-interface" do
    it "loads Baldrick8 web interface page" do
      get board_page_path('baldrick8', 'web-interface', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Web Interface")
    end
  end

  describe "GET /en/boards/baldrick8/faq" do
    it "loads Baldrick8 FAQ page" do
      get board_page_path('baldrick8', 'faq', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("FAQ")
    end
  end

  describe "GET /en/boards/baldrick8/buy-this-board" do
    it "loads Baldrick8 buy page" do
      get board_page_path('baldrick8', 'buy-this-board', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Where to Buy the Baldrick8")
    end
  end

  # Test other board pages
  describe "GET /en/boards/baldrick17" do
    it "loads Baldrick17 overview page" do
      get board_path('baldrick17', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick17")
    end
  end

  describe "GET /en/boards/baldrickbadge" do
    it "loads BaldrickBadge overview page" do
      get board_path('baldrickbadge', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickBadge")
    end
  end

  describe "GET /en/boards/baldrickdmx" do
    it "loads BaldrickDMX overview page" do
      get board_path('baldrickdmx', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickDMX")
    end
  end

  describe "GET /en/boards/baldrickinput1" do
    it "loads BaldrickInput1 overview page" do
      get board_path('baldrickinput1', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickInput1")
    end
  end

  describe "GET /en/boards/baldrickinput8" do
    it "loads BaldrickInput8 overview page" do
      get board_path('baldrickinput8', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickInput8")
    end
  end

  describe "GET /en/boards/baldricksignals" do
    it "loads BaldrickSignals overview page" do
      get board_path('baldricksignals', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickSignals")
    end
  end

  describe "GET /en/boards/baldrickswitchy" do
    it "loads BaldrickSwitchy overview page" do
      get board_path('baldrickswitchy', locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("BaldrickSwitchy")
    end
  end

  # Test other main pages
  describe "GET /en/breakthroughs" do
    it "loads breakthroughs index page" do
      get breakthroughs_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Breakthroughs")
    end
  end

  describe "GET /en/breakthroughs/cunningfx" do
    it "loads CunningFX breakthrough page" do
      get breakthroughs_cunningfx_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("CunningFX")
    end
  end

  describe "GET /en/breakthroughs/busk-board" do
    it "loads Busk Board breakthrough page" do
      get breakthroughs_busk_board_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Busk Board")
    end
  end

  describe "GET /en/breakthroughs/hodgical-test-mode" do
    it "loads Hodgical Test Mode breakthrough page" do
      get breakthroughs_hodgical_test_mode_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Hodgical Test Mode")
    end
  end

  describe "GET /en/breakthroughs/kluster" do
    it "loads Kluster breakthrough page" do
      get breakthroughs_kluster_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("The Kluster")
    end
  end

  describe "GET /en/breakthroughs/ce-ukca-certification" do
    it "loads CE UKCA Certification breakthrough page" do
      get breakthroughs_ce_ukca_certification_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("CE & UKCA Certification")
    end
  end

  describe "GET /en/fun-stuff" do
    it "loads fun stuff index page" do
      get fun_stuff_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Fun Stuff")
    end
  end

  describe "GET /en/fun-stuff/testimonials" do
    it "loads testimonials page" do
      get fun_stuff_testimonials_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Testimonials")
    end
  end

  describe "GET /en/fun-stuff/customer-showcase" do
    it "loads customer showcase page" do
      get fun_stuff_customer_showcase_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Customer Showcase")
    end
  end

  describe "GET /en/fun-stuff/board-dimensions" do
    it "loads board dimensions page" do
      get fun_stuff_board_dimensions_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Board Dimensions")
    end
  end

  describe "GET /en/fun-stuff/stls-and-mounts" do
    it "loads STLs and mounts page" do
      get fun_stuff_stls_and_mounts_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("STLs & Mounts")
    end
  end

  describe "GET /en/fun-stuff/baldrick-buddy" do
    it "loads Baldrick Buddy page" do
      allow(BaldrickBuddy::ReleaseFetcher).to receive(:fetch).and_return(nil)

      get fun_stuff_baldrick_buddy_path(locale: :en)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Baldrick Buddy")
    end
  end

  describe "GET /en/fun-stuff/baldrick-buddy/privacy" do
    it "loads Baldrick Buddy privacy policy page" do
      get fun_stuff_baldrick_buddy_privacy_path(locale: :en)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Privacy Policy")
      expect(response.body).to include("Baldrick Buddy")
    end
  end

  describe "GET /en/support" do
    it "loads support index page" do
      get support_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Support")
    end
  end

  describe "GET /en/support/asking-for-help" do
    it "loads asking for help page" do
      get support_asking_for_help_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Asking for Help")
    end
  end

  describe "GET /en/support/software" do
    it "loads software support page" do
      get support_software_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Software")
    end
  end

  describe "GET /en/faq" do
    it "loads FAQ page" do
      get faq_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("FAQ")
    end
  end

  describe "GET /en/about" do
    it "loads about page" do
      get about_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("About")
    end
  end

  describe "GET /en/where-to-buy-baldrick-boards" do
    it "loads where to buy page" do
      get where_to_buy_baldrick_boards_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Where to Buy")
    end
  end

  # Note: Contact form is handled via POST to /contacts, no GET route exists

  describe "GET /en/feedback" do
    it "loads feedback form" do
      get new_feedback_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Feedback")
    end
  end

  describe "GET /en/newsletter-subscribers/unsubscribe" do
    it "loads unsubscribe page" do
      get newsletter_subscribers_unsubscribe_path(locale: :en)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Unsubscribe")
    end
  end

  describe "GET /2026" do
    it "loads landing page with embedded video and newsletter form" do
      get "/2026"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("youtube.com/embed/d3PKE8uTSp8")
      expect(response.body).to include("youtube.com/embed/_Vxtu50_kb4")
      expect(response.body).to include("newsletter_subscriber")
      expect(response.body).to include("Join our mailing list")
      expect(response.body).to include("Find out when we make our announcements.")
    end
  end
end
