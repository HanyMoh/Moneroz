# == Schema Information
#
# Table name: sections
#
#  id   :integer          not null, primary key
#  code :integer
#  name :string(60)       not null
#

class Section < ApplicationRecord
  has_many :products

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, length: { within: 3..60 }, uniqueness: true

  scope :sorted, -> { order('code DESC') }
  scope :max_code, -> { Section.maximum('code').to_i + 1 }
end
