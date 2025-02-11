Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :sectors, only: [:index]

  resources :route, only: [:index, :create]

  resources :solarsystems, only: [:index], controller: 'solar_systems'

  resources :stars, only: [:index]

  get '/systemmap', to: 'system_map#show'

  get '/solarsystem', to: 'solar_system#show'

  resources :route
end
