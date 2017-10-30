class ProductTransaction < ApplicationRecord

  belongs_to :product
  belongs_to :document

  validates :product_id, :document_id, :quantity_before, :quantity_after, presence: true
  validates_uniqueness_of :product_id, scope: :document_id

end
