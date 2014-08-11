InstrumentchampPrototype::Application.routes.draw do

  ActiveAdmin.routes(self)
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
  get 'index.html', to: redirect("https://www.instrumentchamp.com")

  resources :artists do
    resources :songs do
      get 'free', on: :collection
    end
    get 'most_popular', on: :collection
    get 'top_list', on: :collection
  end

  resources :apps, path: "download"

  resources :challenges do
    get 'yours', on: :collection
    get 'list', on: :collection, as: :list
  end

  constraints id: /[\w\W*]+/ do
    resources :users, as: :people, path: "people" do
      get 'upload_profile_image', on: :member
      get 'list', on: :collection, as: :list
      get 'for_challenge', on: :collection
    end
    resources :user_followers, only: [:show, :create, :destroy]
    resources :following, only: [:show]
  end

  resources :songs do
    get 'free', on: :collection
    get 'for_challenge', on: :collection
    get 'list', on: :collection, as: :list
  end

  resources :user_purchased_songs, path: "paid-songs" do
    get 'buy', on: :member
  end

  resources :categories

  resources :groups do
    get 'members', on: :member
    get 'join', on: :member
    resources :group_invitations
  end

  resources :user_instruments, only: [:edit, :update]
  resources :user_groupies, only: [:index, :create, :destroy]
  resources :user_invitations, only: [:new, :create]

  resources :accounts, path: "account" do
    get 'overview', on: :collection
    get 'profile', on: :collection
    get 'subscription', on: :collection
  end

  resources :user_facebook_invitations do
    post "accept", on: :collection
  end

  get 'welcome' => "welcome#index", as: :welcome

  get 'signup' => "users#new", as: :signup

  resources :facebook_friend_message_modal, only: [:new]

  get 'close_facebook_friend_message_modal', to: "facebook_friend_message_modal#close", as: :close_facebook_friend_message_modal

  resources :sessions, :only => [:new, :create, :destroy]
  get 'login' => "sessions#new", :as => :login
  get 'logout' => "sessions#destroy", :as => :logout

  resources :user_passwords

  resources :password_resets do
    member do
      get :change
      patch :reset
    end
  end

  resources :instruments

  resources :user_premium_subscriptions

  resources :searches, only: [:create, :show] do
    get 'users', on: :member
    get 'my_friends', on: :member
    get 'artists', on: :member
    get 'songs', on: :member
  end

  match '/auth/facebook', via: [:get, :post], as: :facebook_signin
  match 'auth/:provider/callback' => "user_omniauth_credentials#create", via: [:get, :post]
  match 'auth/failure' => "user_omniauth_credentials#failure", via: [:get, :post]

  get 'privacy-policy', to: "statics#privacy_policy", as: :privacy_policy
  get 'terms-of-service', to: "statics#terms_of_service", as: :terms_of_service
  get 'tour', to: "pages#tour", as: :tour
#  get 'premium', to: "statics#premium", as: :premium
#  get 'get-premium', to: "statics#get_premium", as: :get_premium
  get 'get-free', to: "statics#get_free", as: :get_free

  get 'help', to: redirect("https://instrumentchamp.zendesk.com"), as: :help

  get 'mobile-landing', to: "pages#mobile_landing", as: :mobile_landing

  get ':action' => 'pages'

end
