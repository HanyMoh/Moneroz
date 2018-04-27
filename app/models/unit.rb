# == Schema Information
#
# Table name: units
#
#  id   :integer          not null, primary key
#  code :integer
#  name :string(20)       not null
#

class Unit < ApplicationRecord
  has_many :products,     class_name: "Product", foreign_key: 'unit_id'
  has_many :unit_refills, class_name: "Product", foreign_key: 'unit_refill_id'

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, length: { within: 2..20 }, uniqueness: true

  scope :sorted, -> { order('code DESC') }
  scope :max_code, -> { Unit.maximum('code').to_i + 1 }
end
