Rails.application.routes.draw do
  resources :people
  resources :products, :except => [:show]
  resources :units, :except => [:show]
  resources :sections, :except => [:show]
  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
