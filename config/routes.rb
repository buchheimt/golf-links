Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show]
  resources :courses, only: [:index, :show]
  resources :users do
    resources :tee_times, only: [:show]
  end

  root to: "welcome#home"

end
