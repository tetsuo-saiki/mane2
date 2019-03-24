Rails.application.routes.draw do
  get 'pdfs/index'
  devise_for :users
  get 'home/index'
  root to: "home#index"
  resources :items, only: [:index, :create, :show, :destroy]
  resources :user_assets, only: [:index, :create, :destroy]
  resources :asset_transitions, only: [:index, :create, :destroy]
  resources :incomes, only: [:index, :create, :destroy]
  resources :debts, only: [:index, :create, :destroy]
  resources :credit_cards, only: [:index, :create, :destroy]
  resources :amount_used_of_credits, only: [:index, :create, :destroy]
end
