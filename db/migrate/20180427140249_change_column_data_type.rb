class ChangeColumnDataType < ActiveRecord::Migration[5.1]
  def up
    change_column :units, :code, 'integer USING CAST(code AS integer)'
    end

  def down
    change_column :units, :code, :string
  end
end
