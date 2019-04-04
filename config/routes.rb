Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show]
    get '/merchants/:id', to: "merchants#show", as: :merchant
  end

  resources :users, only: [:create, :update]
  get '/profile', to: "users#show"
  get '/profile/edit', to: "users#edit", as: 'edit_profile'
  get '/dashboard/items', to: "merchants/items#index"
  get '/dashboard', to: 'merchants/orders#index'
  get '/cart', to: "cart#show"
  get '/merchants', to: "merchants#index"

  get '/login', to: "sessions#new"
  get '/logout', to: "sessions#show"
  get '/register', to: "users#new"

  resources :items, only: [:index, :show]

end
