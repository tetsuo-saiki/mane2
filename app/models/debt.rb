require 'activerecord-import'

class Debt < ApplicationRecord
  belongs_to :user

  def self.calc_full_payment_date(debt)
    period_spent_in_full_payment = debt.debt_total_amount / debt.debt_withdrawal
    period_spent_in_full_payment = period_spent_in_full_payment.ceil # ceil は切り上げ

    regist_date = Date.new(Date.today.year, Date.today.month, debt.withdrawal_date.to_i)
    
    full_payment_date = regist_date + period_spent_in_full_payment.month
  end
end
