Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :teachers
  resources :admins

  root to: 'main#index'

  # The line below would be unnecessary since we use Google.
  # sessions#new could be left as an empty Ruby function.
  # We just need to define a "new" view to prompt for user name,
  # and password.
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post   '/logout',  to: 'main#logout'

  # Routes for Google authentication, note that these need to be
  # here for ominauth middleware whose route is /auth/google_oauth2,
  # which is not specified in this file, (because the middleware did it).
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')

  # Route for validating forms as an admin
  post '/admin/forms/validate/:id', to: 'teachers#validate', as: "validate"
  post '/admin/forms/delete/:id', to: 'teachers#delete', as: "delete"

  # Route for displaying all teacher information
  get '/all', to: 'teachers#all', as: "all"
end
