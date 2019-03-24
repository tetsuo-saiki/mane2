class AddColumnToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :use_credit, :boolean, default: false, null: false
  end
end
