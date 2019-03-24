class PdfsController < ApplicationController
  include Common

  def index
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
    
    if params[:select_date_start]
      @start = params[:select_date_start]['{}']
      @end = params[:select_date_end]['{}']
    end

    if @start.present? && @end.present?
      # 収入
      @incomes = current_user.incomes.where("income_date between ? and ?", @start, @end).sum("income_amount")
      # 支出
      if params[:include_credit] && params[:include_credit]['flg'] === '1'
        @sum_items = current_user.items.where("date between ? and ?", @start, @end)
          .group(:item_type_id).select("item_type_id, sum(price) as sum_price")
      elsif params[:include_credit]
        @sum_items = current_user.items.where("date between ? and ?", @start, @end)
          .where("use_credit = 0")
          .group(:item_type_id).select("item_type_id, sum(price) as sum_price")
      end
      # カード引き落とし額
      @credits = current_user.credit_cards
        .joins(:amount_used_of_credits)
        .where("amount_used_of_credits.withdrawal_date between ? and ?", @start, @end)
        .group("credit_cards.id")
        .select("credit_cards.id as card_id, credit_cards.title as title, sum(amount_used_of_credits.credit_withdrawal) as sum_withdrawal")
  
      # debtsは選択された日程が1日でも月を跨げば、その月の借金返済総額が表示に追加される
      start_date = Date.parse(@start).beginning_of_month
      end_date = Date.parse(@end)
      # 選択された日付の間の月を配列に格納　between_months => [Tue, 01 Jan 2019, Fri, 01 Feb 2019, Fri, 01 Mar 2019]
      between_months = (start_date..end_date).select {|day| day.day == 1}
      
      debts = 0
      between_months.each do |between_month|
        # 各月の借金返済総額を足していく
        debts += current_user.debts
          .where("created_at < ?", between_month.end_of_month)
          .where("full_payment_date > ?", between_month.beginning_of_month)
          .sum("debt_withdrawal")
      end
      @debts = debts
    end
  end
end
