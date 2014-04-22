InstrumentchampPrototype::Application.routes.draw do

  root to: "pages#home"

  resources :artists do
    resources :songs do
      get 'free', on: :collection
    end
    get 'most_popular', on: :collection
  end

  resources :apps

  resources :challenges do
    get 'yours', on: :collection
  end

  resources :users, as: :people, path: "people", constraints: {id: /[\w\W*]+/} do
    get 'upload_profile_image', on: :member
  end

  resources :songs do
    get 'free', on: :collection
  end

  resources :categories

  resources :user_followers, only: [:create, :destroy]

  get 'signup' => "users#new", as: :signup

  resources :sessions, :only => [:new, :create, :destroy]
  get 'login' => "sessions#new", :as => :login
  get 'logout' => "sessions#destroy", :as => :logout

  resources :user_passwords

  match '/auth/facebook', via: [:get, :post], as: :facebook_signin
  match 'auth/:provider/callback' => "user_omniauth_credentials#create", via: [:get, :post]
  match 'auth/failure' => "user_omniauth_credentials#failure", via: [:get, :post]

  get 'privacy-policy', to: "statics#privacy_policy", as: :privacy_policy
  get 'terms-of-service', to: "statics#terms_of_service", as: :terms_of_service

  get ':action' => 'pages'

end
