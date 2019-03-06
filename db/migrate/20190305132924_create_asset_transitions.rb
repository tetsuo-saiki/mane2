class CreateAssetTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_transitions do |t|
      t.integer :asset_amount, limit: 4, null: false
      t.date :date, null: false
      t.references :user_asset, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
