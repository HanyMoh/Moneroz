class Payment < ApplicationRecord
  belongs_to :storage, class_name: 'Person'
  belongs_to :person
  belongs_to :user

  validates :description, presence: true
  validates :storage_id,  presence: true
  validates :person_id,   presence: true
  validates :money,       presence: true

  scope :sorted, -> { order('created_at DESC') }

  scope :max_code, lambda { |type|
    Payment.where('pay_type = ?', type).maximum('code').to_i + 1
  }

  scope :payments_by_type, lambda { |type, user|
    if user.admin?
      Payment.where('pay_type = ?', type).sorted
    else
      Payment.where('pay_type = ? and user_id = ?', type, user).sorted
    end
  }
end
