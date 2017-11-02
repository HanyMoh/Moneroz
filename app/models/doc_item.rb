# == Schema Information
#
# Table name: doc_items
#
#  id             :integer          not null, primary key
#  document_id    :integer
#  product_id     :integer
#  quantity       :integer          default(1)
#  price          :decimal(11, 2)   default(0.0)
#  effect         :integer          default(0)
#  discount_value :decimal(8, 2)    default(0.0)
#  returned       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_doc_items_on_document_id  (document_id)
#  index_doc_items_on_product_id   (product_id)
#

class DocItem < ApplicationRecord
  belongs_to :document, inverse_of: :doc_items
  belongs_to :product

  ## validates only when subtract from stock
  validate :quantity_compared_to_stock, if: -> { self.effect == 2 }

  attr_accessor :barcode

  scope :invoice_total, lambda { |document_id|
    where('document_id = ?', document_id).sum('(qty * price)- discount').to_f
  }


  ## Methods
  def quantity_compared_to_stock
  	self.errors[:quantity] << "لا يمكن ان تتعدي الكمية المتوفرة في المخزن"  unless self.quantity <= self.product.quantity
  end
end
