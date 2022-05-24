Rails.application.routes.draw do
  root "carriers#index"
  post "carriers/index"
  get "carriers/search", defaults: { format: :json }
end
