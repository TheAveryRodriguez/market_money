Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets do
        resources :vendors, only: [:index]
      end
      resources :vendors
      resources :market_vendors
    end
  end
end
