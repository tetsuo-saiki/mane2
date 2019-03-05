class DebtsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @debts = current_user.debts.order('created_at desc')
    @debt = current_user.debts.build
    @date = Date.today
  end
  
  def create
    @debt = current_user.debts.build(debt_params)
    if @debt.save
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
    flash[:notice] = '項目を削除しました。'
    redirect_to debts_path
  end
  
  private
  
  def debt_params
    params.require(:debt).permit(:title, :debt_total_amount, :withdrawal_amount, :withdrawal_date)
  end
  
  def correct_user
    @debt = current_user.debts.find_by(id: params[:id])
    unless @debt
      redirect_to debts_path
    end
  end
end
    
  