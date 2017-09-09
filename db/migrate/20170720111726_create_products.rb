class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer    :code
      t.string     :name,           :limit => 60, :null => false
      t.string     :barcode,        :limit => 13, :null => false
      t.decimal    :price_in,       precision: 11, scale: 2
      t.decimal    :price_out,      precision: 11, scale: 2
      t.references :section,        index: true
      t.references :unit,           index: true, default: 1
      t.integer    :refill,         default: 1
      t.references :unit_refill,    index: true, default: 2
      t.boolean    :service,        default: false
      t.decimal    :discount_value, precision: 11, scale: 2, default: 0
      t.decimal    :tax,            precision: 11, scale: 2, default: 0
      t.string     :note

      t.timestamps
    end
  end
end
