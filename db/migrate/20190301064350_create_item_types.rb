class CreateItemTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :item_types do |t|
      t.string :item_type, null: false, default: ""
      t.timestamps
    end
  end
end
