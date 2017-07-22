class Person < ApplicationRecord
  PERSON_TYPE = { 1 => "customer",
                  2 => "supplier",
                  3 => "store",
                  4 => "storage",
                  5 => "fee" }.freeze

  has_many :storage_payments, :class_name  => 'Payment',
                              :foreign_key => 'storage_id'

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
