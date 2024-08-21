Rails.application.routes.draw do
  devise_for :users

  get "ui", to: "pages#ui"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :patients, only: [:index, :new, :create, :edit, :update, :destroy] do
    resources :planifications, only: %i[index new create edit update destroy]
  end

  authenticated :user, ->(u) { u.tutor?} do
    root to: "users#home", as: :tutor_root
  end

  authenticated :user, ->(u) { u.patient?} do
    root to: "planifications#index", as: :patient_root
  end

  root to: "pages#home"

  resources :patients, only: [:index, :new, :create, :edit, :update, :destroy, :show]

end
