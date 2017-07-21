class Product < ApplicationRecord
  belongs_to :section
  belongs_to :unit,        class_name: 'Unit'
  belongs_to :unit_refill, class_name: 'Unit', foreign_key: "unit_refill_id"

  validates :name,       length: { within: 3..60 }, uniqueness: true, presence: true
  validates :barcode,    length: { maximum: 13 }, uniqueness: true
  validates :section_id, presence: true

  scope :sorted, -> { order('code DESC') }

  scope :max_code,  -> { Product.maximum('code').to_i + 1 }

  scope :set_barcode, lambda{ |product|
    "#{(product.section.id.to_s).rjust(3, '0')}#{(product.code.to_s).rjust(6, '0')}"
  }

  scope :find_by_barcode, lambda{ |barcode|
    barcode = barcode.gsub(' ', '')
    where('barcode = ?', barcode)
  }

  scope :find_by_Product, lambda{ |name|
    name = name.gsub(' ', '')
    name = "%#{name}%"
    where('name like ?', name)
  }
end