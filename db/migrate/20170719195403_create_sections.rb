class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.integer :code
      t.string  :name, :limit => 60, :null => false
    end
  end
end
