Rails.application.routes.draw do
  get  "/contact", to: "contact#new", as: :contact
  post "/contact", to: "contact#create"

  devise_for :users

  root "home#index"

  get "/about", to: "about#show"
  get "/terms", to: "legal#terms"
  get "/privacy", to: "legal#privacy"
  get "/account", to: "account#show"
  get "/account/details/edit", to: "account#edit_details", as: :edit_account_details
  post "/account/rewards/claim", to: "account#claim_reward", as: :claim_account_reward
  patch "/account/details", to: "account#update_details", as: :update_account_details
  resources :events, only: [ :index ]

  resources :enhancement_requests, only: [ :new, :create, :index ]
  resources :videos, only: [ :index ]
  resources :products, only: [ :index, :show ]
  resources :parts, only: [ :index, :new, :create, :destroy ]
  get "media/*key", to: "s3_proxy#show", as: :s3_media, format: false
  post "/paypal/orders", to: "paypal#orders"
  post "/paypal/orders/:id/capture", to: "paypal#capture"

  namespace :admin do
    root to: "dashboard#index"
    resources :documents, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]
    resources :events, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :orders, only: [ :index, :show ]
    resources :product_variants, only: [ :new, :create, :edit, :update ]
    resources :products, only: [ :index, :new, :create, :edit, :update, :destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
