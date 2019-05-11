class AmountUsedOfCreditsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @selected_month = get_selected_month(params[:select_month])
    @amount_used_of_credits = search(current_user.amount_used_of_credits, @selected_month, "withdrawal_date")
    @sum_monthly_amount_used_of_credits = sum_monthly_amount_of_model(@amount_used_of_credits, "credit_withdrawal")

    @amount_used_of_credit = current_user.amount_used_of_credits.build
    @credit_card_id = current_user.credit_cards.pluck('title', 'id')
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end
  
  def create
    @amount_used_of_credit = current_user.amount_used_of_credits.build(amount_used_of_credit_params)
    if @amount_used_of_credit.save
      reflect_monthly_flow(@amount_used_of_credit.withdrawal_date)

      flash[:notice] = '正常に保存しました。'
      redirect_to amount_used_of_credits_path
    else
      @amount_used_of_credits = current_user.amount_used_of_credits.order('created_at desc')
      # @amount_used_of_credits = current_user.amount_used_of_credits.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'amount_used_of_credits'
    end
  end
  
  def destroy
    # 削除前に日付を取得
    withdrawal_date = @amount_used_of_credit.withdrawal_date
    @amount_used_of_credit.destroy

    reflect_monthly_flow(withdrawal_date)
    flash[:notice] = '項目を削除しました。'
    redirect_to amount_used_of_credits_path
  end
  
  private
  
  def amount_used_of_credit_params
    params.require(:amount_used_of_credit).permit(:using_border, :credit_withdrawal, :credit_card_id, :withdrawal_date)
  end
  
  def correct_user
    @amount_used_of_credit = current_user.amount_used_of_credits.find_by(id: params[:id])
    unless @amount_used_of_credit
      redirect_to amount_used_of_credits_path
    end
  end
  
  def reflect_monthly_flow(withdrawal_date)
    amount_used_of_credits = search(current_user.amount_used_of_credits, withdrawal_date, "withdrawal_date")
    create_or_update_monthly_flow(amount_used_of_credits, "credit_withdrawal", withdrawal_date)
  end
end
  