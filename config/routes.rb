Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root to: "home#index"
  # items
  resources :items, only: [:index, :create, :show, :destroy]
  # assets
  resources :user_assets, only: [:index, :create, :destroy]
  # incomes
  resources :incomes, only: [:index, :create, :destroy]
  # debts
  resources :debts, only: [:index, :create, :destroy]
  # credit_cards
  resources :credit_cards, only: [:index, :create, :destroy]
  # amount_used_of_credits
  resources :amount_used_of_credits, only: [:index, :create, :destroy]
end
