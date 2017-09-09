class CreateDocItems < ActiveRecord::Migration[5.0]
  def change
    create_table :doc_items do |t|
      t.references :document,       index: true
      t.references :product,        index: true
      t.integer    :quantity,       :default => 1
      t.decimal    :price,          precision: 11, scale: 2, :default => 0
      t.integer    :effect,         :default => 0
      t.decimal    :discount_value, precision: 8, scale: 2, :default => 0
      t.boolean    :returned,       :default => false

      t.timestamps
    end
  end
end
