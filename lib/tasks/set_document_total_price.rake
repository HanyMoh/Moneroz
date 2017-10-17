task set_document_total_price: :environment do
	## Description: rake task used to update the final price to be paid for a document
	Document.all.each do |document|
		## 1) count the items sum price
		items_total_price = 0
	    document.doc_items.each do |item|
	      if item.quantity.present? && item.price.present?
	        items_total_price += (item.quantity * item.price.to_f) - item.discount_value.to_f
	      end
	    end
	    # 2) add the tax and sub the discount
	    net = items_total_price + document.tax - document.discount_value
	   	discount_percent = document.discount_ratio * items_total_price / 100;
	    total_price = net - discount_percent
	    # 3) update the document
	    document.total_price = total_price
	    document.save
	end
end
