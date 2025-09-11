Rails.application.routes.draw do
  # Legacy docs redirects (permanent)
  legacy_redirects = [
    ['/docs/baldrick8/qr', '/en/boards/baldrick8'],
    ['/docs/baldrick17/introduction', '/en/boards/baldrick17'],
    ['/docs/switchy/introduction', '/en/boards/baldrickswitchy'],
    ['/docs/input8/', '/en/boards/baldrickinput8'],
    ['/docs/baldrickdmx/introduction', '/en/boards/baldrickdmx'],
    ['/docs/signals/introduction', '/en/boards/baldricksignals'],
    ['/docs/input1/introduction', '/en/boards/baldrickinput1'],
    ['/docs/', '/en/boards/'],
    ['/en/docs/our-boards/', '/en/boards/'],
    ['/docs/baldrick8/web-interface', '/en/boards/baldrick8/web-interface'],
    ['/docs/baldrick17/web-interface', '/en/boards/baldrick17/web-interface'],
    ['/docs/switchy/web-interface', '/en/boards/baldrickswitchy/web-interface'],
    ['/docs/input8/web-interface', '/en/boards/baldrickinput8/web-interface'],
    ['/docs/baldrickdmx/web-interface', '/en/boards/baldrickdmx/web-interface'],
    ['/docs/signals/web-interface', '/en/boards/baldricksignals/web-interface'],
    ['/docs/input1/web-interface', '/en/boards/baldrickinput1/web-interface'],
    ['/docs/baldrick8/getting-started', '/en/boards/baldrick8/getting-started'],
    ['/docs/baldrick17/common-questions', '/en/boards/baldrick17/faq'],
    ['/docs/baldrickdmx/common-questions', '/en/boards/baldrickdmx/faq'],
    ['/docs/signals/common-questions', '/en/boards/baldricksignals/faq'],
    ['/docs/input1/common-questions', '/en/boards/baldrickinput1/faq'],
    ['/docs/input8/common-questions', '/en/boards/baldrickinput8/faq'],
    ['/docs/switchy/common-questions', '/en/boards/baldrickswitchy/faq'],
    ['/docs/baldrick8/common-questions', '/en/boards/baldrick8/faq'],
    ['/docs/baldrick17/common-questions', '/en/boards/baldrick17/faq'],
    ['/en/docs/switchy/first-boot', '/en/boards/baldrickdmx/getting-started'],
    ['/en/docs/input8/first-boot', '/en/boards/baldrickinput8/getting-started'],
    ['/en/docs/baldrickdmx/first-boot', '/en/boards/baldrickdmx/getting-started'],
    ['/en/docs/signals/first-boot', '/en/boards/baldricksignals/getting-started'],
    ['/en/docs/input1/first-boot', '/en/boards/baldrickinput1/getting-started'],
    ['/en/docs/baldrick8/first-boot', '/en/boards/baldrick8/getting-started'],
    ['/en/docs/baldrick17/first-boot', '/en/boards/baldrick17/getting-started'],
    ['/en/docs/category/baldrickswitchy', '/en/boards/baldrickswitchy'],
    ['/en/docs/category/baldrickdmx', '/en/boards/baldrickdmx'],
    ['/en/docs/category/baldricksignals', '/en/boards/baldricksignals'],
    ['/en/docs/category/baldrickinput1', '/en/boards/baldrickinput1'],
    ['/en/docs/category/baldrickinput8', '/en/boards/baldrickinput8'],
    ['/en/docs/category/baldrick8', '/en/boards/baldrick8'],
    ['/en/docs/category/baldrick17', '/en/boards/baldrick17'],
    ['/en/docs/baldrick8/where-to-buy', '/en/boards/baldrick8/where-to-buy'],
    ['/en/docs/baldrick17/where-to-buy', '/en/boards/baldrick17/where-to-buy'],
    ['/en/docs/switchy/where-to-buy', '/en/boards/baldrickswitchy/where-to-buy'],
    ['/en/docs/input8/where-to-buy', '/en/boards/baldrickinput8/where-to-buy'],
    ['/en/docs/baldrickdmx/where-to-buy', '/en/boards/baldrickdmx/where-to-buy'],
    ['/en/docs/signals/where-to-buy', '/en/boards/baldricksignals/where-to-buy'],
    ['/en/docs/input1/where-to-buy', '/en/boards/baldrickinput1/where-to-buy'],
  ]
  
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
    
    resources :feedbacks, only: [:index, :show, :destroy] do
      member do
        patch :mark_processed
      end
    end
  end
  
    # Catch all unmatched routes and show 404 (excluding image files)
    match '*path', to: 'application#not_found', via: :all, constraints: lambda { |req| !req.path.match?(/\.(png|jpg|jpeg|gif|webp|svg|ico)$/i) }
  end
end
