Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  resources :teachers
  resources :admins

  root to: 'main#index'
  get '/dashboard', to: 'main#dashboard'

  # The line below would be unnecessary since we use Google.
  # sessions#new could be left as an empty Ruby function.
  # We just need to define a "new" view to prompt for user name,
  # and password.
  # get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # Routes for Google authentication, note that these need to be
  # here for ominauth middleware whose route is /auth/google_oauth2,
  # which is not specified in this file, (because the middleware did it).
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')

  # Route for validating forms as an admin
  get '/admin/forms', to: 'teachers#forms', as: "forms"
  post '/admin/forms/validate/:id', to: 'teachers#validate', as: "validate"
  post '/admin/forms/delete/:id', to: 'teachers#delete', as: "delete"

  #route for viewing statistics as an admin
  get '/admin/statistics', to: 'schools#statistics', as: "statistics"

end
