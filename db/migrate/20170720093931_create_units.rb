class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :code
      t.string :name, :limit => 20, :null => false
    end
  end
end
