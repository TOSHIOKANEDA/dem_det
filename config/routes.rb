Rails.application.routes.draw do
  root "computings#index"
  post "computings/index"
  get "computings/search", defaults: { format: :json }
end
