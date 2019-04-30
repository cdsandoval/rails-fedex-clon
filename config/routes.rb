Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


  root 'home#index'
  resources :shipment, only: [:show]
  get 'search', to: 'shipment#show'

  namespace :deposit do
    root 'home#index'
    get 'search', to: 'shipment#show'
  end

  namespace :admin do
    root 'home#index'
  end

  namespace :api do
  end

end
