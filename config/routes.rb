Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show, :search, :nearest_atms] do
        resources :vendors, only: [:index]
      end
      resources :vendors
      resources :market_vendors
    end
  end
end
