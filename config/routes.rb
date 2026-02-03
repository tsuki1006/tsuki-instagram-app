require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root 'articles#index'

  devise_for :users

  resources :accounts, only: [ :show ] do
    resources :followings, only: [ :index ]
    resources :followers, only: [ :index ]
  end

  resources :articles, only: [ :index, :show, :new, :create ] do
    resources :comments, only: [ :index, :create ]
  end

  scope module: :apps do
    resource :profile, only: [ :show, :update ]
    resource :timeline, only: [:show]
  end

  namespace :api, defaults: {format: :json} do
    scope '/articles/:article_id' do
      resource :like, only: [ :show, :create, :destroy ]
    end
    scope '/accounts/:account_id' do
      resource :follow, only: [ :show, :create ]
      resource :unfollow, only: [ :create ]
    end
  end
end
