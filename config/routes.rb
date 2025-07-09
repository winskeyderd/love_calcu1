Rails.application.routes.draw do
  devise_for :users
 
  root 'love_calculator#index'
  
  # Love Calculator routes
  post 'calculate', to: 'love_calculator#calculate'
  get 'leaderboard', to: 'love_calculator#leaderboard'
  get 'about', to: 'love_calculator#about'
  get 'contact', to: 'love_calculator#contact'
  
  # User-specific routes
  authenticated :user do
    get 'history', to: 'users#history'
    get 'rewards', to: 'users#rewards'
    get 'profile', to: 'users#profile'
    post 'draw_weekly_card', to: 'users#draw_weekly_card'
  end
end
