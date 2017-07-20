class Section < ApplicationRecord

  validates :name, presence: true,
                   length: { within: 3..60 },
                   uniqueness: true

  scope :sorted, -> { order('code DESC') }
  scope :max_code, -> { Section.maximum('code').to_i + 1 }
end
