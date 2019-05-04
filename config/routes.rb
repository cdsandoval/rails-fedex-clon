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
    resources :sales, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
      root action: "report"
      collection do
        get 'report_countries_recipients', action: 'report_top5_countries_recipients'
        get 'report_countries_senders', action: 'report_top5_countries_senders'
        get 'report_packages_sents', action: 'report_top5_packages_sent'
        get 'report_freight_sents', action: 'report_ranked_freight_value'
      end
    end
    get 'mark_delivered', to: 'shipments#delivered'
    resources :shipments, only: [:update, :new, :create]
    resources :users, only: [:new, :create]
  end

  namespace :api do
    get '/login', to: 'sessions#create'

    resources :shipments, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
      get 'search', action: 'search', on: :collection
    end

    namespace :deposit do
      resources :shipments, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
        get 'search', action: 'search', on: :collection
      end

      resources :shipment_locations, only: [:create] do
        get 'history', action: 'history', on: :collection
      end
    end

    namespace :admin do
      resources :sales, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
        collection do
          get 'report_countries_recipients', action: 'report_top5_countries_recipients'
          get 'report_countries_senders', action: 'report_top5_countries_senders'
          get 'report_packages_sents', action: 'report_top5_packages_sent'
          get 'report_freight_sents', action: 'report_ranked_freight_value'
        end
      end
      resources :shipments, only: [:create, :update] do
        get 'search', action: 'search', on: :collection
      end
      resources :users, only: [:create]
    end
    
  end

end

