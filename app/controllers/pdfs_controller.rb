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
      @incomes = sum_incomes(@start, @end)
      @items = sum_items(@start, @end)
      @credits = sum_credits(@start, @end)
      @debts = sum_debts(@start, @end)
      @total = @incomes - sum_items_total(@start, @end) - sum_credits_total(@start, @end) - @debts
    end
  end

  private

  def sum_incomes(start_day, end_day)
    current_user.incomes.where("income_date between ? and ?", start_day, end_day).sum("income_amount")
  end

  def sum_items(start_day, end_day)
    if params[:include_credit] && params[:include_credit]['flg'] === '1'
      current_user.items.where("date between ? and ?", start_day, end_day)
        .group(:item_type_id).select("item_type_id, sum(price) as sum_price")
    elsif params[:include_credit]
      current_user.items.where("date between ? and ?", start_day, end_day)
        .where("use_credit = 0")
        .group(:item_type_id).select("item_type_id, sum(price) as sum_price")
    end
  end

  def sum_credits(start_day, end_day)
    current_user.credit_cards
      .joins(:amount_used_of_credits)
      .where("amount_used_of_credits.withdrawal_date between ? and ?", start_day, end_day)
      .group("credit_cards.id")
      .select("credit_cards.id as card_id, credit_cards.title as title, sum(amount_used_of_credits.credit_withdrawal) as sum_withdrawal")
  end

  def sum_debts(start_day, end_day)
    # debtsは選択された日程が1日でも月を跨げば、その月の借金返済総額が表示に追加される
    start_date = Date.parse(start_day).beginning_of_month
    end_date = Date.parse(end_day)
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
    debts
  end

  def sum_items_total(start_day, end_day)
    if params[:include_credit] && params[:include_credit]['flg'] === '1'
      current_user.items.where("date between ? and ?", start_day, end_day)
        .sum("price")
    elsif params[:include_credit]
      current_user.items.where("date between ? and ?", start_day, end_day)
        .where("use_credit = 0")
        .sum("price")
    end
  end

  def sum_credits_total(start_day, end_day)
    current_user.amount_used_of_credits
      .where("withdrawal_date between ? and ?", start_day, end_day)
      .sum("credit_withdrawal")
  end
end
