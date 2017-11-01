class ChangeTransactionsSchema < ActiveRecord::Migration[5.0]
  def change
  	rename_table :product_transactions, :sys_transactions
  	rename_column :sys_transactions, :product_id, :loggable_id
  	add_column :sys_transactions, :loggable_type, :string, default: "Product"
  end
end
