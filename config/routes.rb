Rails.application.routes.draw do
  get  "/contact", to: "contact#new", as: :contact
  post "/contact", to: "contact#create"

  devise_for :users

  root "home#index"

  get "/about", to: "about#show"
  get "/account", to: "account#show"

  resources :enhancement_requests, only: [ :new, :create ]
  resources :videos, only: [ :index ]
  resources :products, only: [ :index, :show ]

  namespace :admin do
    root to: "dashboard#index"
    resources :orders, only: [ :index, :show ]
    resources :product_variants, only: [ :new, :create ]
    resources :products, only: [ :new, :create, :edit, :update ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
