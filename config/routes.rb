InstrumentchampPrototype::Application.routes.draw do

  root to: "pages#home"

  resources :artists

  resources :apps

  resources :challenges

  resources :users, as: :peoples, path: "people"

  resources :songs
  resources :categories

  resources :user_sent_facebook_invitations, only: [:create]

  get 'signup' => "users#new", as: :signup

  resources :sessions, :only => [:new, :create, :destroy]
  get 'login' => "sessions#new", :as => :login
  get 'logout' => "sessions#destroy", :as => :logout

  match '/auth/facebook', via: [:get, :post], as: :facebook_signin
  match 'auth/:provider/callback' => "user_omniauth_credentials#create", via: [:get, :post]
  match 'auth/failure' => "user_omniauth_credentials#failure", via: [:get, :post]

  match 'user_sent_facebook_invitations/accept_invitation' => "user_sent_facebook_invitations#accept_invitation", via: [:get, :post]

  get ':action' => 'pages'

end
