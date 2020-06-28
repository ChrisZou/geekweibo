Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :tweets
  resources :users, only: %i[show edit update]
  root to: "tweets#index"
end
