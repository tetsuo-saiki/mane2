class CreateMonthlyFlows < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_flows do |t|
      t.integer :income_amount_sum, limit: 4, null: false, default: 0
      t.integer :price_sum, limit: 4, null: false, default: 0
      t.integer :credit_withdrawal_sum, limit: 4, null: false, default: 0
      t.integer :debt_withdrawal_sum, limit: 4, null: false, default: 0
      t.string :year, null: false
      t.string :month, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
