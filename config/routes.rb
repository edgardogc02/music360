InstrumentchampPrototype::Application.routes.draw do

  root to: "pages#home"

  # redirect old pages cached from google

  get 'contact', to: redirect("https://www.instrumentchamp.com")
  get 'instruments/drum-edition', to: redirect("https://www.instrumentchamp.com")
  get 'systemrequirements', to: redirect("https://www.instrumentchamp.com")
  get 'us/the-willner-brothers/', to: redirect("https://www.instrumentchamp.com")
  get 'general-terms', to: redirect("https://www.instrumentchamp.com")
  get 'category/blog/page/3', to: redirect("https://www.instrumentchamp.com")
  get 're-launch-of-instrumentchamp-com', to: redirect("https://www.instrumentchamp.com")
  get 'instrumentchamp-band-edition-a-real-music-game-official-teaser-trailer-hd', to: redirect("https://www.instrumentchamp.com")
  get 'instrumentchamp-roskilde-festival-2013', to: redirect("https://www.instrumentchamp.com")
  get 'thanks-for-download-win/', to: redirect("https://www.instrumentchamp.com")
  get 'GameManual.pdf', to: redirect("https://www.instrumentchamp.com")
  get 'launchsong', to: redirect("https://www.instrumentchamp.com")

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

  constraints id: /[\w\W*]+/ do
    resources :users, as: :people, path: "people" do
      get 'upload_profile_image', on: :member
    end
    resources :user_followers, only: [:show, :create, :destroy]
    resources :following, only: [:show]
  end

  resources :songs do
    get 'free', on: :collection
    get 'for_challenge', on: :collection
  end

  resources :categories

  resources :user_instruments, only: [:edit, :update]
  resources :user_groupies, only: [:index, :create, :destroy]

  get 'welcome' => "welcome#index", as: :welcome

  get 'signup' => "users#new", as: :signup

  resources :sessions, :only => [:new, :create, :destroy]
  get 'login' => "sessions#new", :as => :login
  get 'logout' => "sessions#destroy", :as => :logout

  resources :user_passwords

  resources :instruments

  match '/auth/facebook', via: [:get, :post], as: :facebook_signin
  match 'auth/:provider/callback' => "user_omniauth_credentials#create", via: [:get, :post]
  match 'auth/failure' => "user_omniauth_credentials#failure", via: [:get, :post]

  match 'facebook_invitations/accept' => "facebook_invitations#accept", via: [:get, :post]

  get 'privacy-policy', to: "statics#privacy_policy", as: :privacy_policy
  get 'terms-of-service', to: "statics#terms_of_service", as: :terms_of_service
  get 'help', to: "statics#help", as: :help
  get 'tour', to: "pages#tour", as: :tour
  get 'premium', to: "statics#premium", as: :premium

  get 'instrument-champ-friends', to: 'users#all_regular_users', as: :instrument_champ_users
  get 'facebook-friends', to: 'users#all_facebook_users', as: :facebook_users
  get 'followed-friends', to: 'users#all_followed_users', as: :followed_users

  get ':action' => 'pages'

end
