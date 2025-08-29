Rails.application.routes.draw do
  # Home page
  root 'pages#home'
  
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
  
  # Where to buy page
  get 'where-to-buy-baldrick-boards', to: 'pages#where_to_buy'
  
  # Support section
  get 'support', to: 'support#index'
  get 'support/software', to: 'support#software'
  get 'support/asking-for-help', to: 'support#asking_for_help'
  
  # Catch all unmatched routes and show 404
  match '*path', to: 'application#not_found', via: :all
end
