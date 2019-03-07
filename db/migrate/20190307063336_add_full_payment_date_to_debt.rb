class AddFullPaymentDateToDebt < ActiveRecord::Migration[5.2]
  def change
    add_column :debts, :full_payment_date, :date
  end
end
