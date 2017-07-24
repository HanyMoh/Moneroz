class Document < ApplicationRecord
  DOC_TYPE = { 1 => "first_term",
               2 => "purchase",
               3 => "sale_cash",
               4 => "selling_futures",
               5 => "returned_sale",
               6 => "returned_buy",
               7 => "barcode" }.freeze

  belongs_to :person
  belongs_to :store,   class_name: 'Person'
  belongs_to :storage, class_name: 'Person'
  belongs_to :user

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
