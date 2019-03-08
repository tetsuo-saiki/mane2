class HomeController < ApplicationController
  include Common

  def index
    @selected_month = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    @display_monthly_flow = display_monthly_flow(@selected_month)
    @incomes = return_daily_flow_of_incomes(@selected_month)
    @items = return_daily_flow_of_items(@selected_month)
    @credits = return_daily_flow_of_credits(@selected_month)
    @debts = return_daily_flow_of_debts(@selected_month)

  end

  private

  def return_daily_flow_of_incomes(selected_month)
    if selected_month
      incomes = current_user.incomes.where("income_date between ? and ?", selected_month.beginning_of_month, selected_month.end_of_month)
    else
      incomes = current_user.incomes.where("income_date between ? and ?", Date.today.beginning_of_month, Date.today.end_of_month)
    end
    incomes.group(:income_date).select("income_date, sum(income_amount) as daily_incomes")
  end

  def return_daily_flow_of_items(selected_month)
    if selected_month
      items = current_user.items.where("date between ? and ?", selected_month.beginning_of_month, selected_month.end_of_month)
    else
      items = current_user.items.where("date between ? and ?", Date.today.beginning_of_month, Date.today.end_of_month)
    end
    items.group(:date).select("date, sum(price) as daily_item_price")
  end

  def return_daily_flow_of_credits(selected_month)
    if selected_month
      credits = current_user.amount_used_of_credits.where("withdrawal_date between ? and ?", selected_month.beginning_of_month, selected_month.end_of_month)
    else
      credits = current_user.amount_used_of_credits.where("withdrawal_date between ? and ?", Date.today.beginning_of_month, Date.today.end_of_month)
    end
    credits.group(:withdrawal_date).select("withdrawal_date, sum(credit_withdrawal) as daily_credit_withdrawal")
  end

  def return_daily_flow_of_debts(selected_month)
    if selected_month
      debts = current_user.debts.where("full_payment_date > ?", selected_month.beginning_of_month)
                .where("created_at < ?", selected_month.end_of_month)
    else
      debts = current_user.debts.where("full_payment_date > ?", Date.today.beginning_of_month)
                .where("created_at < ?", Date.today.end_of_month)
    end
    debts.group(:withdrawal_date).select("withdrawal_date, sum(debt_withdrawal) as daily_debt_withdrawal")
  end
end
