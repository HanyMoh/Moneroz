class AddSysTransactionsDocumentable < ActiveRecord::Migration[5.0]
  def change
  	rename_column :sys_transactions, :document_id, :documentable_id
  	add_column :sys_transactions, :documentable_type, :string, default: "Document"
  end
end
