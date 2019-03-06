class AddWithdrawalDateToAmountUsedOfCredit < ActiveRecord::Migration[5.2]
  def change
    add_column :amount_used_of_credits, :withdrawal_date, :date
  end
end
