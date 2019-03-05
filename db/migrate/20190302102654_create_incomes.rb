class CreateIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :incomes do |t|
      t.string :title, null: false
      t.integer :income_amount, limit: 4, null: false
      t.date :income_date, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
