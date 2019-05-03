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
    get "sales/report_countries_recipients",to: 'sales#report_top5_countries_recipients'
    get "sales/report_countries_senders", to: 'sales#report_top5_countries_senders'
    get "sales/report_packages_sents", to: 'sales#report_top5_packages_sent'
    get "sales/report_freight_sents", to: 'sales#report_ranked_freight_value'
    get 'mark_delivered', to: 'shipments#delivered'
    resources :shipments, only: [:new, :create, :update] do
      get 'search', action: 'search', on: :collection
    end
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

    namespace :admin do
      get  'sales', to: 'sales#report'
      resources :shipments, only: [:new, :create, :update] do
        get 'search', action: 'search', on: :collection
      end
      resources :users, only: [:new, :create]
    end
    
  end

end

