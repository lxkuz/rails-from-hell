Rails.application.routes.draw do
 resources :items, only: [:index, :create]
 get '/items/clear_all', to: "items#clear_all"
 root 'items#index'
end
