Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # all actions needed for RESTful Users resource & a number of named routes
  resources :users

  # only need one route (GET request, URL: /account_activation/<token>/edit, Named Route: edit_account_activation_url(token))
  resources :account_activations, only: [:edit]

  # GET requests for new and edit, POST for create, and PATCH for update
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :microposts, only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
