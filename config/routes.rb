Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  get '/auth/facebook/callback', to: 'sessions#create'

  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :courses, only: [:index, :show]
  resources :users do
    resources :tee_times, only: [:new, :create, :show, :edit, :update]
  end
  resources :tee_times, only: [:index, :show]
  resources :user_tee_times, only: [:index, :create]

  root to: "welcome#home"

end
