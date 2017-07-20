class Person < ApplicationRecord
  validates :name, presence: true, length: { within: 3..60 }, uniqueness: { scope: [:person_type] }

  scope :sorted, -> { order('created_at DESC') }

  scope :max_code, lambda { |type|
    Person.where('person_type = ?', type).maximum('code').to_i + 1
  }

  scope :people_by_type, lambda { |type|
    Person.where('person_type = ?', type).sorted
  }

  def full_description
    "#{self.name} --- #{self.person_type}".html_safe
  end
end
