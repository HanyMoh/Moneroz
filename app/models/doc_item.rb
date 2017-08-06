class DocItem < ApplicationRecord
  belongs_to :document, inverse_of: :doc_items
  belongs_to :product

  attr_accessor :barcode

  scope :invoice_total, lambda { |document_id|
    where('document_id = ?', document_id).sum('(qty * price)- discount').to_f
  }
end
