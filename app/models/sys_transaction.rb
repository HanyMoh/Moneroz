class SysTransaction < ApplicationRecord

  belongs_to :loggable, :polymorphic => true
  belongs_to :document

  validates :loggable_id, :loggable_type, :document_id, :quantity_before, :quantity_after, presence: true
  validates_uniqueness_of :document_id, scope: [:loggable_type, :loggable_id]

end
