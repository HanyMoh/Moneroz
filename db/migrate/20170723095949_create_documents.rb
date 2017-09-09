class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.date :doc_date
      t.integer    :code
      t.references :store,          index: true
      t.references :storage,        index: true
      t.references :person,         index: true
      t.references :user,           index: true
      t.decimal    :payment,        precision: 11, scale: 2, :default => 0
      t.integer    :doc_type,       :default => 0
      t.integer    :effect,         :default => 0
      t.decimal    :discount_value, precision: 8, scale: 2, :default => 0
      t.decimal    :discount_ratio, precision: 8, scale: 2, :default => 0
      t.decimal    :tax,            precision: 8, scale: 2, :default => 0
      t.boolean    :hold,           :default => false
      t.string     :note

      t.timestamps
    end
  end
end
