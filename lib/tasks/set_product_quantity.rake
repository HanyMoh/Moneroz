task set_product_quantity: :environment do
	## Description: this task is used to update product current_quantity depending on purchase and sell documents
	Product.all.each do |product|
		quantity = 0
		## get doc items that have changes to this product
		doc_items = DocItem.where(product_id: product.id)
		doc_items.each do |item|
			if item.effect == 1 ## increase quantity
				quantity += item.quantity
			elsif item.effect == 2 ## decrease quantity
				quantity -= item.quantity
			end		
		end

	    product.quantity = quantity
	    product.save
	end
end
