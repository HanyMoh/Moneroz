class DocItem < ApplicationRecord
  belongs_to :document
  belongs_to :product

  attr_accessor :barcode

  scope :invoice_total, lambda { |document_id|
    where('document_id = ?', document_id).sum('(quantity * price)- discount_value').to_f
  }
end
