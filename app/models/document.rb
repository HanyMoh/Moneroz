class Document < ApplicationRecord
  DOC_TYPE = { 1 => "أول المدة",
               2 => "مشتريات",
               3 => "بيع نقدى",
               4 => "بيع آجل",
               5 => "مرتجع بيع",
               6 => "مرتجع شراء",
               7 => "باركود" }.freeze

  has_many   :doc_items, inverse_of: :document, dependent: :destroy
  belongs_to :person
  belongs_to :store,   class_name: 'Person'
  belongs_to :storage, class_name: 'Person'
  belongs_to :user

  accepts_nested_attributes_for :doc_items, reject_if: proc { |attributes| attributes[:product_id].blank? }, allow_destroy: true

  validates :code, uniqueness: { scope: [:doc_type] }

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
end
