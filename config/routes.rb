Rails.application.routes.draw do
  devise_for :users
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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
