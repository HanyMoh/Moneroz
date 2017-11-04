# == Schema Information
#
# Table name: documents
#
#  id             :integer          not null, primary key
#  doc_date       :date
#  code           :integer
#  store_id       :integer
#  storage_id     :integer
#  person_id      :integer
#  user_id        :integer
#  payment        :decimal(11, 2)   default(0.0)
#  doc_type       :integer          default(0)
#  effect         :integer          default(0)
#  discount_value :decimal(8, 2)    default(0.0)
#  discount_ratio :decimal(8, 2)    default(0.0)
#  tax            :decimal(8, 2)    default(0.0)
#  hold           :boolean          default(FALSE)
#  note           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  total_price    :decimal(, )
#
# Indexes
#
#  index_documents_on_person_id   (person_id)
#  index_documents_on_storage_id  (storage_id)
#  index_documents_on_store_id    (store_id)
#  index_documents_on_user_id     (user_id)
#








class Document < ApplicationRecord
  DOC_TYPE = { 1 => "أول المدة",
               2 => "مشتريات",
               3 => "بيع نقدى",
               4 => "بيع آجل",
               5 => "مرتجع بيع",
               6 => "مرتجع شراء",
               7 => "باركود" }.freeze

  has_many :doc_items, inverse_of: :document, dependent: :destroy
  has_many :products, through: :doc_items
  has_many :sys_transactions, :as => :documentable
  belongs_to :person
  belongs_to :store,   class_name: 'Person'
  belongs_to :storage, class_name: 'Person'
  belongs_to :user

  accepts_nested_attributes_for :doc_items, reject_if: proc { |attributes| attributes[:product_id].blank? }, allow_destroy: true

  validates :code, uniqueness: { scope: [:doc_type] }
  validates :doc_date, presence: true

  after_save :update_products_quantity, :create_person_transaction, :create_storage_transaction

  scope :sorted, -> { order('created_at DESC') }

  scope :max_code, lambda { |doc_type|
    where('doc_type = ?', doc_type).maximum('code').to_i + 1
  }

  scope :invoices, lambda { |doc_type, user|
    if user.admin?
      where('doc_type = ?', doc_type).sorted
    else
      where('doc_type = ? and user_id = ?', doc_type, user).sorted
    end
  }

  scope :period_filter, -> (filter) {
    if filter[:doc_date_from].present? || filter[:doc_date_to].present?
      date_from = filter.delete(:doc_date_from) || Document.minimum(:doc_date).to_s
      date_to = filter.delete(:doc_date_to) || Date.today.to_s
      includes(:products).includes(:person).includes(:storage).includes(:user).where(doc_date: date_from..date_to).where(filter)
    else
      includes(:products).includes(:person).includes(:storage).includes(:user).where(filter)
    end
  }

  def label
    "#{DOC_TYPE[doc_type]} رقم #{id}"
  end

  def update_products_quantity
    self.doc_items.includes(:product).each do |item|
      product = item.product
      quantity_before_change = product.quantity
      if item.effect == 1 ## increase quantity
        product.quantity += item.quantity
      elsif item.effect == 2 ## decrease quantity
        product.quantity -= item.quantity
      end 
      if quantity_before_change != product.quantity ## quantity changed
        product.sys_transactions.new(
              documentable: self, quantity_before: quantity_before_change, quantity_after: product.quantity)
        product.save
        
      end
    end
  end

  def create_person_transaction
    if self.total_price - self.payment > 0 ## not fully paid document, so changes person balance
      self.person.create_person_transaction(self)   
    end
  end

  def create_storage_transaction
    if self.payment.to_i > 0 ## payment paid document, so changes storage balance(some money goes in to the storage)
      self.storage.create_storage_transaction(self)   
    end
  end

end
