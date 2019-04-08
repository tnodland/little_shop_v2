Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show]
    get '/merchants/:id', to: "merchants#show", as: :merchant
    get '/merchants', to: "merchants#index", as: :merchants
    patch '/merchant/:merchant_id/', to: "merchants#update", as: :merchant_change_status
  end

  resources :items, only: [:index, :show]
  resources :orders, only: [:create]
  resources :users, only: [:create, :update]

  namespace :profile do
    resources :orders, only: [:index, :show]
  end

  get '/profile/orders', to: "orders#index"
  post 'profile/orders/:id', to: 'profile/orders#cancel', as: 'cancel_order'
  get '/profile', to: "users#show", as: 'profile'
  get '/profile/edit', to: "users#edit", as: 'edit_profile'

  get '/dashboard', to: 'merchants/orders#index'
  scope :dashboard, module: :merchants, as: :dashboard do
    resources :items, only: [:index, :destroy, :update, :new, :create, :edit]
    resources :orders, only: [:show]
  end

  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#destroy'
  patch '/cart', to: 'carts#update'
  resources :carts, only: [:create]

  get '/merchants', to: "merchants#index"
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"
  get '/register', to: "users#new"

end
