class Unit < ApplicationRecord
  validates :name, presence: true,
                   length: { within: 2..20 },
                   uniqueness: true

  scope :sorted, -> { order('code DESC') }
  scope :max_code, -> { Unit.maximum('code').to_i + 1 }
end
