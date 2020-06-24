Rails.application.routes.draw do
  devise_for :users
  resources :tweets
  resources :users, only: %i[show edit update]
  root to: "tweets#index"
end
