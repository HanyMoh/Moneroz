class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.integer :code
      t.string  :name,        :limit => 60, :null => false
      t.integer :person_type,  default: 1
      t.string  :phone,       :limit => 25
      t.string  :address
      t.string  :note

      t.timestamps
    end
  end
end
