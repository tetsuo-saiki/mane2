class CreateDebts < ActiveRecord::Migration[5.2]
  def change
    create_table :debts do |t|
      t.string :title, null: false
      t.integer :debt_total_amount, limit: 4, null: false
      t.integer :withdrawal_amount, limit: 4, null: false
      t.string :withdrawal_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
