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

## pay_type(1)=> "إيصال استلام نقدية", "استلام"
## pay_type(2) => "إيصال صرف نقدية", "صرف"


class Payment < ApplicationRecord
  belongs_to :storage, class_name: 'Person'
  belongs_to :person
  belongs_to :user
  has_many   :sys_transactions, :as => :documentable

  validates :description, presence: true
  validates :storage_id,  presence: true
  validates :person_id,   presence: true
  validates :money,       presence: true
  validates :pay_date, presence: true

  # after_save :create_person_transaction
  after_save :create_balance_transactions

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

  scope :period_filter, -> (filter) {
    if filter[:doc_date_from].present? || filter[:doc_date_to].present?
      date_from = filter.delete(:doc_date_from) || Payment.minimum(:pay_date).to_s
      date_to = filter.delete(:doc_date_to) || Date.today.to_s
      # includes(:person).includes(:user).where(pay_date: date_from..date_to).where(person_id: filter["people.id"])
      includes(:person).includes(:user).includes(:storage).where(pay_date: date_from..date_to).where(filter)
    else
      # includes(:person).includes(:user).where(person_id: filter["people.id"])
      includes(:person).includes(:user).includes(:storage).where(filter)
    end
  }

  ## Methods
  def create_balance_transactions
    self.person.create_person_transaction(self)
    self.storage.create_storage_transaction(self)
  end

  def label
    "مستند سداد رقم #{self.id}"
  end

  def self.cash_in_payments_count
    where(pay_type: 1).count
  end
end
