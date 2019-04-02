Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :admin do
    get '/dashboard', to: "orders#index"
    resources :users, only: [:index, :show]
    get '/merchants/:id', to: "merchants#show", as: :merchants
  end

  get '/dashboard', to: "merchant/items#index"
  get '/profile', to: "users#show"
  get '/cart', to: "cart#show"
  get '/merchants', to: "merchants#show"

  resources :items, only: [:index, :show]

end
