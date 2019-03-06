class Income < ApplicationRecord
  belongs_to :user


  # 選択月のincomeの合計
  def self.sum_monthly_income(user, selected_month)
    if selected_month
      user.incomes.where('income_date between ? and ?', selected_month.beginning_of_month, selected_month.end_of_month).sum(:income_amount)
    else
      nil
    end
  end

end
