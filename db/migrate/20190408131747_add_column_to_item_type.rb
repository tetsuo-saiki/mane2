class AddColumnToItemType < ActiveRecord::Migration[5.2]
  def change
    add_reference :item_types, :user, foreign_key: true
  end
end
