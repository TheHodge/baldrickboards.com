Rails.application.routes.draw do
  # Legacy docs redirects (permanent)
  
  # Board name mappings (old_name => new_name)
  board_mappings = {
    'baldrick8' => 'baldrick8',
    'baldrick17' => 'baldrick17', 
    'switchy' => 'baldrickswitchy',
    'input8' => 'baldrickinput8',
    'baldrickdmx' => 'baldrickdmx',
    'signals' => 'baldricksignals',
    'input1' => 'baldrickinput1',
    'baldrickbadge' => 'baldrickbadge'
  }
  
  # Page type mappings (old_page => new_page)
  page_mappings = {
    'common-questions' => 'faq',
    'board-overview' => 'tech-specs',
    'first-boot' => 'getting-started',
    'first-boot/xlights_connection' => 'getting-started',
    'first-boot/connecting_pixels' => 'getting-started',
    'first-boot/attaching-power' => 'getting-started',
    'first-boot/installing-firmware' => 'getting-started',
    'where-to-buy' => 'buy-this-board',
    'web-interface' => 'web-interface',
    'web-interface/stats' => 'web-interface#stats-dashboard',
    'web-interface/turninput-configuration' => 'web-interface#turninput-configuration',
    'web-interface/networking' => 'web-interface#networking',
    'web-interface/advanced-settings' => 'web-interface#advanced-settings',
    'web-interface/advanced' => 'web-interface#advanced-settings',
    'web-interface/ports' => 'web-interface#port-configuration',
    'web-interface/turnip-network' => 'web-interface#turnip-network',
    'common-questions/fpp_api_commands' => 'faq#fpp-api-commands'
  }
  
  # Build redirects array
  legacy_redirects = []
  
  # General redirects
  legacy_redirects += [
    ['/docs/intro', '/en'],
    ['/docs/', '/en/boards/'],
    ['/docs/', '/en/boards/'],
    ['/docs/release-notes', '/en/fun-stuff/release-notes'],
    ['/docs/our-boards/', '/en/boards/'],
    ['/docs/common-questions/hodgical-test-mode', '/en/breakthroughs/hodgical-test-mode'],
    ['/docs/common-questions/baldrick-stl-mounts', '/en/fun-stuff/stls-and-mounts',],
    ['/docs/category/common-questions', '/en/faq'],
    ['/docs/category/common-questions-1', '/en/faq'],
    ['/docs/category/common-questions-2', '/en/faq'],
    ['/docs/category/common-questions-3', '/en/faq'],
    ['/docs/category/common-questions-4', '/en/faq'],
    ['/docs/turnip-network', '/en/breakthroughs/turnip-network'],
    ['/docs/where-to-buy', '/en/where-to-buy-baldrick-boards'],
    ['/docs/common-questions/ipconfig_check', '/en/faq#ipconfig-check'],
    ['/docs/baldrick8/web-interface/inputs', '/en/breakthroughs/turniput'],
    ['/docs/baldrick8/web-interface/test', '/en/boards/baldrick8/web-interface#test-mode'],
    ['/docs/baldrick8/common-questions/what-is-the-difference-of-the-xtreme-edition', '/en/boards/baldrick8/faq#xtreme-edition'],
    ['/docs/baldrick8/common-questions/where_is_wifi', '/en/boards/baldrick8/faq#where-is-wifi'],
    ['/docs/baldrick17/common-questions/gs8208-data', '/en/boards/baldrick8/faq#gs8208-data'],
    ['/docs/baldrick17/common-questions/where_is_wifi', '/en/boards/baldrick8/faq#where-is-wifi'],
    ['/docs/baldrick17/common-questions/is_this_wled', '/en/boards/baldrick8/faq#is-this-wled'],
    ['/docs/baldrick8/common-questions/is_this_wled', '/en/boards/baldrick8/faq#is-this-wled'],
    ['/docs/signals/web-interface/crowd', '/en/boards/baldricksignals/web-interface#crowd-control'],
    ['/docs/signals/export-data', '/en/boards/baldricksignals/getting-started'],
    ['/docs/switchy/web-interface/relay-config', '/en/boards/baldrickswitchy/web-interface#relay-configuration'],
    ['/docs/switchy/web-interface/wled-config', '/en/boards/baldrickswitchy/web-interface#wled-configuration'],
    ['/docs/switchy/web-interface/network-config', '/en/boards/baldrickswitchy/web-interface#network-configuration'],
    ['/docs/switchy/web-interface/ports', '/en/boards/baldrickswitchy/web-interface#port-configuration'],
    ['/docs/switchy/web-interface/turnip-network', '/en/boards/baldrickswitchy/web-interface#turnip-network'],
    ['/docs/switchy/web-interface/test', '/en/boards/baldrickswitchy/web-interface#test-mode'],
    ['/docs/switchy/common-questions/fpp_api_commands', '/en/boards/baldrickswitchy/faq#fpp-api-commands'],
    ['/docs/switchy/first-boot/connecting_devices', '/en/boards/baldrickswitchy/getting-started'],
    ['/docs/switchy/board_overview', '/en/boards/baldrickswitchy'],
    ['/docs/switchy/release_notes', '/en/fun-stuff/release-notes'],
    ['/docs/switchy/common-questions/what_is_the_tray', '/en/boards/baldrickswitchy/faq#darwin-tray'],
    ['/docs/switchy/common-questions/what_is_the_power_consumption', '/en/boards/baldrickswitchy/faq#power-consumption'],
    ['/docs/switchy/common-questions/where-is-wifi', '/en/boards/baldrickswitchy/faq#where-is-wifi'],
    ['/docs/baldrickdmx/web-interface/presets', '/en/boards/baldrickdmx/web-interface#presets'],
    ['/docs/switchy/web-interface/data-settings', '/en/boards/baldrickswitchy/web-interface#data-settings'],
    ['/docs/common-questions/fpp-proxy', '/en/faq#fpp-proxy'],
    ['/docs/category/baldrick16', '/en/boards/baldrick17'],
    ['/docs/baldrick8/common-questions/hodgical-test-mode', '/en/breakthroughs/hodgical-test-mode'],
    ['/docs/common-questions/antennas', '/en/faq#antennas'],
    ['/docs/hardware-support', '/en/support'],
    ['/docs/category/beginners-guide', '/en/beginners-guide'],
    ['/docs/beginners-guide', '/en/beginners-guide'],
    ['/docs/beginners-guide/introduction', '/en/beginners-guide'],
    ['/docs/beginners-guide/hardware-basics', '/en/beginners-guide'],
    ['/docs/beginners-guide/how-to-start', '/en/beginners-guide'],
    ['/docs/beginners-guide/shopping-list', '/en/beginners-guide'],
    ['/17', 'en/boards/baldrick17'],
    ['/docs/baldrickbadge/matrix', 'en/boards/baldrickbadge/getting-started'],
    ['/docs/input1/turniput', 'en/boards/breakthroughs/turniput'],
    ['/docs/input1/getting-started/power-the-board', 'en/boards/baldrickinput1/getting-started'],
    ['/docs/input1/getting-started/install-firmware','en/boards/baldrickinput1/getting-started'],
    ['/docs/input1/getting-started/action', 'en/boards/baldrickinput1/getting-started'],
    ['/docs/input1/getting-started/button-wire', 'en/boards/baldrickinput1/getting-started'],
    ['/docs/common-questions/why_no_screen', 'en/faq#why-no-screen'],
    ['/docs/baldrick8/common-questions/asking-for-help', 'en/support#asking-for-help'],
    ['/docs/common-questions/baldrick-dimensions', 'en/fun-stuff/board-dimensions'],
    ['/docs/common-questions/find_board_ip', 'en/faq#find-board-ip']
  ]
  
  # Board-specific redirects
  board_mappings.each do |old_board, new_board|
    # Introduction pages
    legacy_redirects << ["/docs/#{old_board}/introduction", "/en/boards/#{new_board}"]
    legacy_redirects << ["/docs/#{old_board}/", "/en/boards/#{new_board}"]
    legacy_redirects << ["/docs/#{old_board}/qr", "/en/boards/#{new_board}"]
    # Category pages
    legacy_redirects << ["/docs/category/#{new_board}", "/en/boards/#{new_board}"]
    
    # Page type redirects
    page_mappings.each do |old_page, new_page|
      legacy_redirects << ["/docs/#{old_board}/#{old_page}", "/en/boards/#{new_board}/#{new_page}"]
    end    
  end
    
  legacy_redirects.each do |old_path, new_path|
    get old_path, to: redirect(new_path), status: 301
    get "/en#{old_path}", to: redirect(new_path), status: 301
  end
  
  # Search logging endpoints (no locale needed for API endpoints)
  post "search_logs/log_search", to: "search_logs#log_search"
  post "search_logs/log_click", to: "search_logs#log_click"
  
  # Locale-based routing
  scope "(:locale)", locale: /en|es|fr|de/ do
    # Home page
    root 'pages#home'
  
  # Search test page
  get 'search-test', to: 'pages#search_test'
  
  # Boards section
  get 'boards', to: 'boards#index'
  
  # Board category routes
  get 'boards/pixel-controllers', to: 'boards#pixel_controllers'
  get 'boards/relay-controllers', to: 'boards#relay_controllers'
  get 'boards/interactive-controllers', to: 'boards#interactive_controllers'
  get 'boards/portable-controllers', to: 'boards#portable_controllers'
  get 'boards/power-distribution', to: 'boards#power_distribution'
  get 'boards/dmx-controllers', to: 'boards#dmx_controllers'
  
  # Generic board routes - handles all board pages automatically
  get 'boards/:board', to: 'boards#show', as: :board
  get 'boards/:board/:page', to: 'boards#show', as: :board_page
  
  # About Baldrick section
  get 'about', to: 'about#index'
  
  # Baldrick Breakthroughs section
  get 'breakthroughs', to: 'breakthroughs#index'
  get 'breakthroughs/turnip-network', to: 'breakthroughs#turnip_network'
  get 'breakthroughs/kluster', to: 'breakthroughs#kluster'
  get 'breakthroughs/ce-ukca-certification', to: 'breakthroughs#ce_ukca_certification'
  get 'breakthroughs/turniput', to: 'breakthroughs#turniput'
  get 'breakthroughs/hodgical-test-mode', to: 'breakthroughs#hodgical_test_mode'
  get 'breakthroughs/cunningfx', to: 'breakthroughs#cunningfx'
  
  # FAQ section
  get 'faq', to: 'faq#index'
  
  # Beginners Guide section
  get 'beginners-guide', to: 'pages#beginners_guide'
    
    # Fun Stuff section
  get 'fun-stuff', to: 'fun_stuff#index'
  get 'fun-stuff/release-notes', to: 'fun_stuff#release_notes'
  get 'fun-stuff/stls-and-mounts', to: 'fun_stuff#stls_and_mounts'
  get 'fun-stuff/board-dimensions', to: 'fun_stuff#board_dimensions'
  get 'fun-stuff/faq', to: 'fun_stuff#faq'
  get 'fun-stuff/problem-solver', to: 'fun_stuff#problem_solver'
  get 'fun-stuff/panic-mode', to: 'fun_stuff#panic_mode'
  get 'fun-stuff/testimonials', to: 'fun_stuff#testimonials'
  get 'fun-stuff/customer-showcase', to: 'fun_stuff#customer_showcase'
    
  # Where to buy page
  get 'where-to-buy-baldrick-boards', to: 'pages#where_to_buy'
  
  # Support section
  get 'support', to: 'support#index'
  get 'support/software', to: 'support#software'
  get 'support/asking-for-help', to: 'support#asking_for_help'
  
  # Christmas Triage
  namespace :triage do
    resources :cases, only: [:index, :new, :create, :show, :edit, :update] do
      collection do
        get :my_cases
        post :send_magic_link
        get :magic_link_login
        get :magic_link_sent
        delete :logout
      end
      member do
        get :verify_access
        post :verify_access
        get :mark_solved
        patch :mark_solution_fixed
      end
    end
  end
  
  # Contact form
  post 'contacts', to: 'contacts#create'
  
  # Feedback form
  get 'feedback', to: 'feedbacks#new', as: 'new_feedback'
  post 'feedback', to: 'feedbacks#create'
  get 'feedback/success', to: 'feedbacks#success', as: 'feedbacks_success'
  
  # Newsletter signup
  post 'newsletter_subscribers', to: 'newsletter_subscribers#create'
  get 'newsletter_subscribers/unsubscribe', to: 'newsletter_subscribers#unsubscribe'
  
  # Sitemap
  get 'sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  
  # Analytics with Ahoy
  # Analytics handled by custom admin controller
  
  # Admin area
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    # Admin dashboard
    root 'dashboard#index'
    
    # Analytics redirect
    get 'analytics', to: 'analytics#index'
    
    resources :newsletter_subscribers, only: [:index, :destroy], path: 'newsletter-subscribers' do
      collection do
        get :export_csv
      end
    end
    
    resources :search_logs, only: [:index, :destroy], path: 'search-logs'
    
    resources :error_logs, only: [:index, :show, :destroy], path: 'error-logs' do
      collection do
        delete :clear_all
      end
    end    
    resources :feedbacks, only: [:index, :show, :destroy] do
      member do
        patch :mark_processed
      end
    end
    
    # Triage management
    resources :triage_cases, path: 'triage/cases', only: [:index, :show, :update, :destroy] do
      member do
        patch :update_status
      end
    end
    resources :triage_solutions, path: 'triage/solutions'
  end
  
    # Catch all unmatched routes and show 404 (excluding image files and Active Storage)
    match '*path', to: 'application#not_found', via: :all, constraints: lambda { |req| 
      !req.path.match?(/\.(png|jpg|jpeg|gif|webp|svg|ico)$/i) && 
      !req.path.start_with?('/rails/active_storage')
    }
  end
end
