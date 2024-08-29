Rails.application.routes.draw do
  devise_for :users

  get "ui", to: "pages#ui"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  authenticated :user, ->(u) { u.tutor?} do
    root to: "users#home", as: :tutor_root
  end

  authenticated :user, ->(u) { u.patient?} do
    root to: "takes#index", as: :patient_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  resources :patients, only: [:new, :create, :edit, :update, :destroy] do
    resources :planifications, only: %i[index new create]
    member do
      get 'cam'
    end
    resources :takes, only: %i[index]
    resources :patient_takes, only: %i[index]
  end

  resources :planifications, only: %i[edit update destroy] do
    member do
      get 'confirm'
    end
    collection do
      post 'photo'
    end
  end

  resources :tutor_patients, only: [:show] do
    resources :chats, only: [:create]
  end

  resources :takes, only: [] do
    member do
      get 'cam_patient'
      post 'photo'
      patch 'taken'
    end
  end

end
