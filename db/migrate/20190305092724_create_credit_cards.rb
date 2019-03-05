class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.string :title, null: false
      t.date :use_period, null: false
      t.integer :use_border, limit: 4, null: false
      t.string :withdrawal_date, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
