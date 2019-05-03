Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'
  resources :shipments do
    get 'search', action: 'search', on: :collection
  end

  namespace :deposit do
    root 'home#index'
    resources :shipments, only: [:index, :show] do
      get 'search', action: 'search', on: :collection
    end
        
    resources :shipment_locations, only: [:create]
  end

  namespace :admin do
    root 'home#index'
    get  'sales', to: 'sales#report'
    get 'mark_delivered', to: 'shipments#delivered'
    resources :shipments, only: [:update, :new, :create]
    resources :users, only: [:new, :create]
  end

  namespace :api do
    get '/login', to: 'sessions#create'

    resources :shipments, only: [:index] do
      get 'search', action: 'search', on: :collection
    end

    namespace :deposit do
      resources :shipments, only: [:index] do
        get 'search', action: 'search', on: :collection
      end

      resources :shipment_locations, only: [:create] do
        get 'history', action: 'history', on: :collection
      end
    end
    
  end

end

