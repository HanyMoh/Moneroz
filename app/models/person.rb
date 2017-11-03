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
  has_many :payments

  validates :name, presence: true, length: { within: 3..60 }, uniqueness: { scope: [:person_type] }

  scope :sorted, -> { order('created_at DESC') }

  scope :max_code, lambda { |type|
    Person.where('person_type = ?', type).maximum('code').to_i + 1
  }

  scope :people_by_type, lambda { |type|
    Person.where('person_type = ?', type).sorted
  }

  ## Methods
  def full_description
    "#{Person::PERSON_TYPE[id]} - #{self.name}".html_safe
  end

  def create_person_transaction(document)
    person = self
    balance_before_change = person.sys_transactions.any? ? person.sys_transactions.last.quantity_after : 0
    # rest = (document.total_price - document.payment).to_i
    change_amount = document.class == Document ? (document.total_price - document.payment).to_i : document.money.to_i
    balance = balance_before_change
    case person.person_type
    when 1 ## customer
      if document.class == Document
        balance += change_amount
      else ## payment class
        balance -= change_amount
      end
    when 2 ## supplier
      if document.class == Document
        balance -= change_amount
      else ## payment class
        balance += change_amount
      end
    end
    ## document is the documentable that cause changes to balance
    person.sys_transactions.new(documentable: document, 
      quantity_before: balance_before_change , quantity_after: balance)
    person.save
  end

  def create_storage_transaction(document)
    storage = self
    balance_before_change = storage.sys_transactions.any? ? storage.sys_transactions.last.quantity_after : 0
    change_amount = document.class == Document ? document.payment.to_i : document.money.to_i
    balance = balance_before_change
    case document.person.person_type
    when 1 ## customer documents adds to storage credit
        balance += change_amount
    when 2 ## supplier documents sub from storage credit
        balance -= change_amount
    end
    ## document is the documentable that cause changes to balance
    storage.sys_transactions.new(documentable: document, 
      quantity_before: balance_before_change , quantity_after: balance)
    storage.save
  end
end
