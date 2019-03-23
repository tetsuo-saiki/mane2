class DebtsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @selected_month = get_selected_month(params[:select_month])
    @debts = debt_search(@selected_month)
    @sum_monthly_debts = sum_monthly_amount_of_model(@debts, "debt_withdrawal")
    @debt = current_user.debts.build
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end
  
  def create
    @debt = current_user.debts.build(debt_params)
    @debt.full_payment_date = Debt.calc_full_payment_date(@debt)
    if @debt.save
      reflect_debt_to_monthly_flow(@debt)
      flash[:notice] = '正常に保存しました。'
      redirect_to debts_path
    else
      @debts = current_user.debts.order('created_at desc')
      # @debts = current_user.debts.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'debts'
    end
  end
  
  def destroy
    @debt.destroy
    # reflect_debt_to_monthly_flow
    flash[:notice] = '項目を削除しました。'
    redirect_to debts_path
  end
  
  private
  
  def debt_params
    params.require(:debt).permit(:title, :debt_total_amount, :debt_withdrawal, :withdrawal_date)
  end
  
  def correct_user
    @debt = current_user.debts.find_by(id: params[:id])
    unless @debt
      redirect_to debts_path
    end
  end

  def debt_search(selected_month)
    if selected_month
      current_user.debts.where("created_at < ?", selected_month.end_of_month).where("full_payment_date > ?", selected_month.beginning_of_month)
    else
      current_user.debts.where("created_at < ?", Date.today.end_of_month).where("full_payment_date > ?", Date.today.beginning_of_month)
    end
  end

  # したいこと　debt登録時、削除時に monthly_flwo テーブルに反映させたい
  # activerecord-import を使用した bulkupdate では Mysql2::Error: Duplicate entry 'id' for key 'PRIMARY': INSERT INTO `monthly_flows` が発生し、
  # on_duplicate_key_update を使っても解決できぬ
  # TODO: 月計算のマスタいらないんじゃない？清宮さん
  # def reflect_debt_to_monthly_flow(debt)
  #   begin_date = Date.today.beginning_of_month
  #   end_date = debt.full_payment_date.beginning_of_month
  #   upsert_monthly_flows = []
  #   while begin_date != end_date + 1.month
  #     monthly_debt = current_user.debts.where("full_payment_date > ?", begin_date).where("created_at < ?", begin_date.end_of_month).sum("debt_withdrawal")
  #     if current_user.monthly_flows.where(["year = ? and month = ?", begin_date.year, begin_date.month])[0]
  #       exist_monthly_flow = current_user.monthly_flows.where(["year = ? and month = ?", begin_date.year, begin_date.month])[0]
  #       exist_monthly_flow.debt_withdrawal_sum = monthly_debt
  #       upsert_monthly_flows << exist_monthly_flow
  #     else
  #       upsert_monthly_flows << current_user.monthly_flows.build(debt_withdrawal_sum: monthly_debt, year: begin_date.year, month: begin_date.month)
  #     end
  #     begin_date += 1.month
  #   end
  #   MonthlyFlow.import upsert_monthly_flows, on_duplicate_key_update: [:debt_withdrawal_sum]
  # end

  # やむなく通常のupsert
  def reflect_debt_to_monthly_flow(debt)
    begin_date = Date.today.beginning_of_month
    end_date = debt.full_payment_date.beginning_of_month
    while begin_date != end_date + 1.month
      monthly_debt = current_user.debts.where("full_payment_date > ?", begin_date).where("created_at < ?", begin_date.end_of_month).sum("debt_withdrawal")
      if current_user.monthly_flows.where(["year = ? and month = ?", begin_date.year, begin_date.month])[0]
        exist_monthly_flow = current_user.monthly_flows.where(["year = ? and month = ?", begin_date.year, begin_date.month])[0]
        exist_monthly_flow.debt_withdrawal_sum = monthly_debt
        exist_monthly_flow.save!
      else
        new_monthly_flow = current_user.monthly_flows.build(debt_withdrawal_sum: monthly_debt, year: begin_date.year, month: begin_date.month)
        new_monthly_flow.save!
      end
      begin_date += 1.month
    end
  end
end
