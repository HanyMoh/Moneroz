class ChangeProductQuantityDefault < ActiveRecord::Migration[5.0]
  def change
  	change_column_default(:products, :quantity, 0)
  end
end
