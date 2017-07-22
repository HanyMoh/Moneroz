class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer    :code
      t.date       :pay_date
      t.integer    :pay_type
      t.integer    :effect
      t.references :storage,    index: true
      t.references :person,     index: true
      t.decimal    :money,      precision: 8, scale: 2
      t.string     :description
      t.references :user,       index: true
      t.string     :note

      t.timestamps
    end
  end
end
