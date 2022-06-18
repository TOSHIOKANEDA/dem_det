Rails.application.routes.draw do
  root "computings#index"
  post "computings/index"
  get "computings/search", defaults: { format: :json }
  get "owns/index"
  get "owns/calcurate", defaults: { format: :json }
end
