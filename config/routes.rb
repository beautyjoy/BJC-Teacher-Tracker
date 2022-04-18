# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :teachers do
    member do
      post :resend_welcome_email
      post :validate
      post :delete
      post :deny
    end
    collection { post :import }
  end
  resources :schools
  resources :email_templates, only: [:index, :update, :edit]
  root to: "main#index"

  # The line below would be unnecessary since we use Google.
  # sessions#new could be left as an empty Ruby function.
  # We just need to define a "new" view to prompt for user name,
  # and password.
  get    "/login",   to: "sessions#new"
  delete "/logout",  to: "sessions#destroy"

  get "auth/:provider/callback", to: "sessions#omniauth_callback"

  get "/dashboard", to: "main#dashboard", as: "dashboard"

  resources :dynamic_pages, except: [:edit] do
    member do
      post :delete
    end
  end

  get "pages/:slug", to: "dynamic_pages#show"
  get "pages/edit/:slug", to: "dynamic_pages#edit"
end
