Rails.application.routes.draw do
  root 'matches#index'
  resources :matches
  get '/stats' => 'matches#stats', :as => 'stats'
  post '/stats' => 'matches#stats'
end
