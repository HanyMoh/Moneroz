# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  code        :integer
#  pay_date    :date
#  pay_type    :integer
#  effect      :integer
#  storage_id  :integer
#  person_id   :integer
#  money       :decimal(8, 2)
#  description :string
#  user_id     :integer
#  note        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_payments_on_person_id   (person_id)
#  index_payments_on_storage_id  (storage_id)
#  index_payments_on_user_id     (user_id)
#

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
