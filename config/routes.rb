Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :shipment, only: [:show]
  get 'search', to: 'shipment#show'

  devise_for :users

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