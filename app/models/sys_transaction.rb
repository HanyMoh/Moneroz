# == Schema Information
#
# Table name: sys_transactions
#
#  id                :integer          not null, primary key
#  loggable_id       :integer
#  documentable_id   :integer
#  quantity_before   :integer
#  quantity_after    :integer
#  loggable_type     :string           default("Product")
#  documentable_type :string           default("Document")
#

class SysTransaction < ApplicationRecord

  belongs_to :loggable, :polymorphic => true ## loggable can be for 'Product' or 'Person'
  belongs_to :documentable, :polymorphic => true ## document can be either 'Document' or 'Payment'
  # belongs_to :document, -> { where(sys_transactions: {documentable_type: 'Document'}) }, foreign_key: 'documentable_id'

  validates :loggable_id, :loggable_type, :documentable_id, :documentable_type, :quantity_before, :quantity_after, presence: true
  validates_uniqueness_of :documentable_id, scope: [:documentable_type, :loggable_type, :loggable_id]

end
