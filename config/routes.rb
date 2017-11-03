Rails.application.routes.draw do
  get 'homes/index'
  root 'homes#index'
  # devise_for :users, controllers: { confirmations: 'confirmations'}
  # devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", sessions: 'users/sessions' }
  devise_scope :user do
    get "/users/finish_signup" => "users/omniauth_callbacks#finish_signup"
    post "/users/finished_signup" => "users/omniauth_callbacks#finished_signup"
    get "/users/finish_signup_google" => "users/omniauth_callbacks#finish_signup_google"
    post "/users/finished_signup_google" => "users/omniauth_callbacks#finished_signup_google"
    # get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    # delete "/users/sign_out" => "devise/sessions#destroy"
    # delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  # devise_scope :user do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #   # patch '/users/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  # end
  # as :user do
    # delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #   patch '/users/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  # # post '/users/new' => 'users#new', :via => :post, :as => :new
  # end
  resources :users do
    member do
      get 'customize'
      put 'u_customize'
      patch 'u_customize'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
