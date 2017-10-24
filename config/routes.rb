Rails.application.routes.draw do

  get 'home/new'
  get 'documents/give_me_barcode'
  get 'documents/give_me_product'
  resources :documents do
    resources :doc_items
    collection do
      get :dashboard
      # ------------------
      get :add_first_term
      get :add_purchase
      get :add_sale_cash
      get :add_selling_futures
      get :add_returned_sale
      get :add_returned_buy
      get :add_barcode
      # -----------------
      get :first_term
      get :purchase
      get :sale_cash
      get :selling_futures
      get :returned_sale
      get :returned_buy
      get :barcode
      ## reports
      get :autocomplete_product_name
      get :autocomplete_person_name
      get :per_product
      get :per_customer
      get :per_supplier
    end
  end

  resources :payments do
    collection do
      get :cash_in
      get :cash_out
    end
  end

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

  resources :products do
    collection do
      ## reports
      get :autocomplete_product_name
      get :inventory
    end
  end
  resources :units, :except => [:show]
  resources :sections, :except => [:show]
  root to: 'home#index'

end
