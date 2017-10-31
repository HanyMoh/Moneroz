# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  code        :integer
#  name        :string(60)       not null
#  person_type :integer          default(1)
#  phone       :string(25)
#  address     :string
#  note        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Person < ApplicationRecord
  PERSON_TYPE = { 1 => "customer",
                  2 => "supplier",
                  3 => "store",
                  4 => "storage",
                  5 => "fee" }.freeze

  has_many :documents
  has_many :storage_payments,  :class_name  => 'Payment',  :foreign_key => 'storage_id'
  has_many :storage_documents, :class_name  => 'Document', :foreign_key => 'storage_id'
  has_many :store_documents,   :class_name  => 'Document', :foreign_key => 'store_id'
  has_many :sys_transactions, :as => :loggable

  validates :name, presence: true, length: { within: 3..60 }, uniqueness: { scope: [:person_type] }

  scope :sorted, -> { order('created_at DESC') }

  scope :max_code, lambda { |type|
    Person.where('person_type = ?', type).maximum('code').to_i + 1
  }

  scope :people_by_type, lambda { |type|
    Person.where('person_type = ?', type).sorted
  }

  def full_description
    "#{Person::PERSON_TYPE[id]} - #{self.name}".html_safe
  end
end
