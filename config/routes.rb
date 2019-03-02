Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root to: "home#index"
  # items
  resources :items, only: [:index, :create, :show, :destroy]
  # assets
  resources :user_assets, only: [:index, :create, :destroy]
end
