InstrumentchampPrototype::Application.routes.draw do

  root to: "pages#home"

  resources :artists

  resources :apps

  resources :challenges

  resources :users, as: :peoples, path: "people"

  resources :songs
  resources :categories

  get 'signup' => "users#new", as: :signup

  resources :sessions, :only => [:new, :create, :destroy]
  get 'login' => "sessions#new", :as => :login
  get 'logout' => "sessions#destroy", :as => :logout

  match 'auth/:provider/callback' => "user_omniauth_credentials#create", via: [:get, :post]
  match 'auth/failure' => "user_omniauth_credentials#failure", via: [:get, :post]

  get ':action' => 'pages'

end
