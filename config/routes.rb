Rails.application.routes.draw do
  resources :locations

  resources :events do
    member do
      get 'map'
    end
  end

  resources :categories

  root 'events#map'
end
