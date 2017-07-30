Rails.application.routes.draw do

  # resources :documents do
  #   resources :doc_items
  #   collection do
  #     get :first_term
  #     get :purchase
  #     get :sale_cash
  #     get :selling_futures
  #     get :returned_sale
  #     get :returned_buy
  #     get :barcode
  #     # Add new
  #     get :add_first_term
  #     get :add_purchase
  #     get :add_sale_cash
  #     get :add_selling_futures
  #     get :add_returned_sale
  #     get :add_returned_buy
  #     get :add_barcode
  #   end
  # end

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
      # ------------------
      # get :first_term_list
      # get :purchase_list
      # get :sale_cash_list
      # get :selling_futures_list
      # get :returned_sale_list
      # get :returned_buy_list
      # get :barcode_list
      # get :order_purchase_list
      # get :receive_items_list
      # get :exchange_items_list
      # get :subtract_items_list
      # get :add_items_list
      # get :transfer_items_list
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

  resources :products
  resources :units, :except => [:show]
  resources :sections, :except => [:show]
  root to: 'home#index'

end
