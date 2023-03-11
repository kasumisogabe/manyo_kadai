Rails.application.routes.draw do
  get 'users/new'
  resources :users
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks do
    collection do
      get 'search'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]

end
