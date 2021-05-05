Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :teachers do
    post :resend_welcome_email
    post :validate, as: "validate"
    post :delete, as: "delete"
    post :deny, as: "deny"
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

  # Routes for Google authentication, note that these need to be
  # here for ominauth middleware whose route is /auth/google_oauth2,
  # which is not specified in this file, (because the middleware did it).
  get "auth/:provider/callback", to: "sessions#generalAuth"

  get "/dashboard", to: "main#dashboard", as: "dashboard"
end
