class AddTotalPriceToDocuments < ActiveRecord::Migration[5.0]
  def change
  	add_column :documents, :total_price, :decimal
  end
end
