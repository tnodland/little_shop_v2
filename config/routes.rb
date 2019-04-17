Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show] do
      resources :orders, only: [:show]
      post 'orders/:id', to: 'orders#cancel'
    end
    get '/users/:id/upgrade', to: "users#upgrade", as: 'upgrade_user'
    get '/merchants/:id/downgrade', to: "merchants#downgrade", as: 'downgrade_merchant'
    resources :merchants, only: [:index, :show]
    resources :orders, only: [:update]
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
    get '/order/:id', to: 'orders#show', as: 'order'
    get '/download_current/:merchant_id', to: 'orders#current', as: :download_current
    get '/download_potential/:merchant_id', to: 'orders#potential', as: :download_potential
  end
  patch '/dashboard/:order/:item/fulfill', to: "merchants/orders#update", as: :fulfill_item

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
