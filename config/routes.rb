Rails.application.routes.draw do
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
  
  # Admin area
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    # Admin dashboard
    root 'dashboard#index'
    
    resources :newsletter_subscribers, only: [:index, :destroy] do
      collection do
        get :export_csv
      end
    end
    
    resources :search_logs, only: [:index]
    
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
