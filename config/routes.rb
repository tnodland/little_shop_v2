Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show]
    get '/users/:id/upgrade', to: "users#upgrade", as: 'upgrade_user'
    get '/merchants/:id/downgrade', to: "merchants#downgrade", as: 'downgrade_merchant'
    resources :merchants, only: [:index, :show]
    patch '/merchant/:merchant_id/', to: "merchants#update", as: :merchant_change_status
  end

  resources :users, only: [:create, :update]

  scope :profile, as: :profile do
    resources :orders, only: [:index, :show], module: :profile
    post 'orders/:id', to: 'profile/orders#cancel', as: 'cancel_order'
    get '/', to: "users#show"
    get '/edit', to: "users#edit"
  end

  scope :dashboard, module: :merchants, as: :dashboard do
    resources :items, only: [:index, :destroy, :update, :new, :create, :edit]
    get '/', to: 'orders#index'
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

  resources :items, only: [:index, :show]
  resources :orders, only: [:create]
end
