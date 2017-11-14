Rails.application.routes.draw do
  get 'homes/index'
  root 'homes#index'
  # devise_for :users, controllers: { confirmations: 'confirmations'}
  # devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "acme/registrations", :verification => "custom_verification", :sessions => "acme/sessions"}, :path => 'u'
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", sessions: 'users/sessions' }
  resources :users
  resources :jobs do
    resources :applicants, only: [:new, :create]
    get 'search', on: :collection
  end
  devise_scope :user do
    get "/users/finish_signup" => "users/omniauth_callbacks#finish_signup"
    post "/users/finished_signup" => "users/omniauth_callbacks#finished_signup"
    get "/users/finish_signup_google" => "users/omniauth_callbacks#finish_signup_google"
    post "/users/finished_signup_google" => "users/omniauth_callbacks#finished_signup_google"
    # get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    # delete "/users/sign_out" => "devise/sessions#destroy"
    # delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  resources :verifications, only: [:create] do
    collection do
      patch 'mobile'
      patch 'delete_number'
    end
  end

  # post 'verifications' => 'verifications#create'
  patch 'verifications' => 'verifications#verify'
  # patch 'verifications' => 'verfication#mobile'
  resources :users do
    member do
      get 'customize'
      put 'u_customize'
      patch 'u_customize'
    end
  end
  resources :validates, only: [:index]
  namespace :api do
    namespace :v1 do
      resources :validates
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
