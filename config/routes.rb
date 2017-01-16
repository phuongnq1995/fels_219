Rails.application.routes.draw do
  root "static_pages#home"
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users, expect: :destroy
  resources :categories do
    resources :lessons
    member do
      get "restore"
      delete "really_destroy"
    end
  end

  resources :words do
    member do
      get "restore"
      delete "really_destroy"
    end
  end

  resources :users do
    resources :following, only: :index
    resources :followers, only: :index
  end

  resources :relationships, only: [:create, :destroy]
  resources :following, only: :index
  resources :followers, only: :index
end
