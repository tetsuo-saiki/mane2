class AmountUsedOfCreditsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @amount_used_of_credits = current_user.amount_used_of_credits.order('created_at desc')
    @amount_used_of_credit = current_user.amount_used_of_credits.build
    @credit_card_id = CreditCard.pluck('title', 'id')
    @date = Date.today
  end
  
  def create
    @amount_used_of_credit = current_user.amount_used_of_credits.build(amount_used_of_credit_params)
    if @amount_used_of_credit.save
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
    @amount_used_of_credit.destroy
    flash[:notice] = '項目を削除しました。'
    redirect_to amount_used_of_credits_path
  end
  
  private
  
  def amount_used_of_credit_params
    params.require(:amount_used_of_credit).permit(:using_border, :withdrawal_amount, :credit_card_id)
  end
  
  def correct_user
    @amount_used_of_credit = current_user.amount_used_of_credits.find_by(id: params[:id])
    unless @amount_used_of_credit
      redirect_to amount_used_of_credits_path
    end
  end
end
  