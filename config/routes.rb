Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show]
    get '/merchants/:id', to: "merchants#show", as: :merchant
  end

  resources :users, only: [:create]
  get '/dashboard/items', to: "merchants/items#index"
  get '/dashboard', to: 'merchants/orders#index'
  get '/profile', to: "users#show"
  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#destroy'
  resources :carts, only: [:create]
  get '/merchants', to: "merchants#index"

  get '/login', to: "sessions#new"
  get '/logout', to: "sessions#show"
  get '/register', to: "users#new"

  resources :items, only: [:index, :show]
  resources :users
end
