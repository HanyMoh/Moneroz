class AddProductTransactions < ActiveRecord::Migration[5.0]
  def change
  	create_table :product_transactions do |t|
  		t.integer :product_id
  		t.integer :document_id
  		t.integer :quantity_before
  		t.integer :quantity_after
  	end
  end
end
