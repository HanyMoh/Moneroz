# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  code           :integer
#  name           :string(60)       not null
#  barcode        :string(13)       not null
#  price_in       :decimal(11, 2)
#  price_out      :decimal(11, 2)
#  section_id     :integer
#  unit_id        :integer          default(1)
#  refill         :integer          default(1)
#  unit_refill_id :integer          default(2)
#  service        :boolean          default(FALSE)
#  discount_value :decimal(11, 2)   default(0.0)
#  tax            :decimal(11, 2)   default(0.0)
#  note           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  quantity       :integer          default(0)
#
# Indexes
#
#  index_products_on_name            (name)
#  index_products_on_section_id      (section_id)
#  index_products_on_unit_id         (unit_id)
#  index_products_on_unit_refill_id  (unit_refill_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#  fk_rails_...  (unit_id => units.id)
#

class Product < ApplicationRecord
  has_many   :doc_items
  has_many   :document, :through => :doc_items
  has_many   :sys_transactions, :as => :loggable
  belongs_to :section
  belongs_to :unit,        class_name: 'Unit'
  belongs_to :unit_refill, class_name: 'Unit', foreign_key: 'unit_refill_id'

  validates :name,       length: { within: 3..60 }, uniqueness: true, presence: true
  validates :barcode,    length: { maximum: 13 }, uniqueness: true
  validates :section_id, presence: true

  scope :sorted, -> { order('code DESC') }

  scope :max_code,  -> { Product.maximum('code').to_i + 1 }

  scope :generat_barcode, lambda{ |product|
    "#{product.section.id.to_s.rjust(3, '0')}#{product.code.to_s.rjust(6, '0')}"
  }

  scope :get_product_by_barcode, lambda{ |barcode|
    barcode = barcode.delete(' ')
    barcode = "%#{barcode}%"
    where('barcode like ?', barcode)
  }

  scope :get_product_by_name, lambda{ |name|
    name = name.delete(' ')
    name = "%#{name}%"
    where('name like ?', name)
  }
end
