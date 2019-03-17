class CreditCardsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @credit_cards = current_user.credit_cards.order('created_at desc')
    @credit_card = current_user.credit_cards.build
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end
  
  def create
    @credit_card = current_user.credit_cards.build(credit_card_params)
    if @credit_card.save
      flash[:notice] = '正常に保存しました。'
      redirect_to credit_cards_path
    else
      @credit_cards = current_user.credit_cards.order('created_at desc')
      # @credit_cards = current_user.credit_cards.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'credit_cards'
    end
  end
  
  def destroy
    @credit_card.destroy
    flash[:notice] = '項目を削除しました。'
    redirect_to credit_cards_path
  end
  
  private
  
  def credit_card_params
    params.require(:credit_card).permit(:title, :use_period, :use_border, :withdrawal_date)
  end
  
  def correct_user
    @credit_card = current_user.credit_cards.find_by(id: params[:id])
    unless @credit_card
      redirect_to credit_cards_path
    end
  end
end
