task set_person_storage_transactions: :environment do
	## Description: this task is used to create previous financial changes transactions 
	## depending on purchase and sell documents in addition to payments

	## getting documents that are not fully paid plus payments (considering payment as a document)
	all_documents = (Document.includes(:person).where("total_price - payment > 0") + Payment.all.includes(:person))
	all_documents.sort_by{|document| document.class == Document ? document.doc_date : document.pay_date }.each do |document|
		person = document.person
  		person.create_person_transaction(document)
  	end

	## getting documents that have money paid plus payments (considering payment as a document)
  	all_documents = (Document.includes(:storage).where("payment > 0") + Payment.all.includes(:storage))
	all_documents.sort_by{|document| document.class == Document ? document.doc_date : document.pay_date }.each do |document|
  		storage = document.storage
  		storage.create_storage_transaction(document)
	end
end
