Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :teachers # Note we're not actually using all of these...
  resources :admins   # Note we're not actually using all of these...
  resources :schools, only: [:new, :create, :index]
  resources :email_templates, only: [:index, :update, :edit]
  root to: "main#index"

  # The line below would be unnecessary since we use Google.
  # sessions#new could be left as an empty Ruby function.
  # We just need to define a "new" view to prompt for user name,
  # and password.
  get    "/login",   to: "sessions#new"
  delete "/logout",  to: "sessions#destroy"
  post   "/logout",  to: "main#logout"

  # Routes for Google authentication, note that these need to be
  # here for ominauth middleware whose route is /auth/google_oauth2,
  # which is not specified in this file, (because the middleware did it).
  get "auth/google_oauth2/callback", to: "sessions#googleAuth"
  get "auth/microsoft_graph/callback", to: "sessions#microsoftAuth"
  get "auth/failure", to: redirect("/")

  # Route for validating forms as an admin
  # TODO: #21 - move to teachers/:id/...
  post "/admin/forms/validate/:id", to: "teachers#validate", as: "validate"
  post "/admin/forms/delete/:id", to: "teachers#delete", as: "delete"
  post "/admin/forms/deny/:id", to: "teachers#deny", as: "deny"

  get "/dashboard", to: "main#dashboard", as: "dashboard"
end
