 # frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "bin/rails routes".
  root to: "main#index"

  resources :teachers do
    member do
      post :resend_welcome_email
      post :validate
      post :deny
      post :request_info
    end
    collection { post :import }
  end
  resources :schools
  resources :pages, param: :url_slug
  resources :email_templates, only: [:index, :update, :edit]

  get    "/login",  to: "sessions#new",     as: "login"
  delete "/logout", to: "sessions#destroy", as: "logout"
  # These are pulled from Discourse
  post "session/sso" => "sessions#sso"
  get "session/sso_login" => "sessions#sso_login"

  get "/auth/:provider/callback", to: "sessions#omniauth_callback"

  get "/dashboard", to: "main#dashboard", as: "dashboard"
end
