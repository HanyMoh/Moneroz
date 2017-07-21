Rails.application.routes.draw do

  devise_for :users
  resources :users

  resources :people do
    collection do
      get :suppliers
      get :customers
      get :stores
      get :storages
      get :fees
    end
  end
  resources :products
  resources :units, :except => [:show]
  resources :sections, :except => [:show]
  root to: 'home#index'
end
