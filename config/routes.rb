Rails.application.routes.draw do
  root "farms#index"

  resources :farms, only: [ :index, :show ]
  resources :zones, only: [ :show ]
  resources :alerts, only: [ :index ]
end
