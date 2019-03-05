class CreateAmountUsedOfCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :amount_used_of_credits do |t|
      t.integer :using_border, limit: 4, null: false
      t.integer :withdrawal_amount, limit: 4, null: false
      t.references :credit_card, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
