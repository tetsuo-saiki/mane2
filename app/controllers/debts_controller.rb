class DebtsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @debts = current_user.debts.order('created_at desc')
    @sum_monthly_debts = sum_monthly_amount_of_model(@debts, "debt_withdrawal")
    @debt = current_user.debts.build
    @date = Date.today
  end
  
  def create
    @debt = current_user.debts.build(debt_params)
    @debt.full_payment_date = Debt.calc_full_payment_date(@debt)
    if @debt.save
      reflect_debt_to_monthly_flow
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
    reflect_debt_to_monthly_flow
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

  # not use bulk update (tmp)
  def reflect_debt_to_monthly_flow
    monthly_sum = sum_monthly_amount_of_model(current_user.debts, "debt_withdrawal")
    monthly_flows = current_user.monthly_flows
    if !monthly_flows.empty?
      monthly_flows.each do |monthly_flow|
        monthly_flow.debt_withdrawal_sum = monthly_sum
        monthly_flow.save!
      end
    end
  end
  # use bulk update
  # def reflect_debt_to_monthly_flow
  #   monthly_sum = sum_monthly_amount_of_model(current_user.debts, "debt_withdrawal")
  #   monthly_flows = current_user.monthly_flows # 今は期間関係なく全取得している
  #   if !monthly_flows.empty?
  #     update_monthly_flows = []
  #     monthly_flows.each do |monthly_flow|
  #       monthly_flow.debt_withdrawal_sum = monthly_sum
  #       update_monthly_flows << monthly_flow
  #     end
  #     monthly_flows.import update_monthly_flows, on_duplicate_key_update: [:debt_withdrawal_sum]
  #   end
  # end
end
    
  