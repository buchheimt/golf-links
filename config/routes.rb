Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
  get '/auth/facebook/callback', to: 'sessions#create'

  get '/users/:id/favorite_course', to: 'courses#favorite_course', as: 'user_favorite_course'
  get '/courses/most_popular', to: 'courses#most_popular', as: 'most_popular_course'

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :tee_times, only: [:index, :new, :create, :show]
  end
  resources :courses, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :tee_times, only: [:new, :create, :show]
  end
  resources :tee_times, only: [:index, :show, :new, :create]
  resources :user_tee_times, only: [:create, :update, :destroy]

  resources :comments, only: [:create]

  get '/courses/:id/prev', to: 'courses#prev', as: 'prev_course'
  get '/courses/:id/next', to: 'courses#next', as: 'next_course'

  get '/about', to: 'welcome#about'
  root to: 'welcome#home'

end
