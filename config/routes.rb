Rails.application.routes.draw do
  get 'demo/cache'
  namespace :admin do
      resources :users
      resources :tweets
      resources :likes
      resources :notifications
      resources :comments

      root to: "users#index"
    end
  get 'about/index'
  get 'welcome/agreement'
  post "notifications/mark_read"
  resources :notifications, only: :index
  resources :comments, only: [:create, :destroy]
  resources :tags, only: :show
  resources :likes, only: :create
  delete "/likes", to: 'likes#destroy'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :tweets
  resources :users, only: %i[show edit update]
  get "/users/:id/tweets", to: "users#tweets"
  root to: "tweets#index"
end
