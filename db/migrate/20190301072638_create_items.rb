class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.integer :price, limit: 4, null: false
      t.string :image_url
      t.date :date
      t.references :item_type, foreign_key: true
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
