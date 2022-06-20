Rails.application.routes.draw do
  root "owns#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations' 
  }

  resources :tariffs
  get "computings/index"
  post "computings/index"
  get "computings/search", defaults: { format: :json }
  get "owns/index"
  get "owns/calcurate", defaults: { format: :json }
end
