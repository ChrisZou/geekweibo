Rails.application.routes.draw do
  resources :comments
  resources :tags, only: :show
  resources :likes, only: :create
  delete "/likes", to: 'likes#destroy'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :tweets
  resources :users, only: %i[show edit update]
  root to: "tweets#index"
end
