Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  get '/auth/facebook/callback', to: 'sessions#create'

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :tee_times, only: [:new, :create, :show]
  end
  resources :courses, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :tee_times, only: [:new, :create, :show]
  end
  resources :tee_times, only: [:index, :show, :new, :create]
  resources :user_tee_times, only: [:create, :destroy]

  get '/users/:id/favorite_course', to: 'courses#favorite_course', as: "user_favorite_course"

  root to: "welcome#home"
  get '/about', to: "welcome#about"

end
