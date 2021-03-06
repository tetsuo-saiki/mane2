class IncomesController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @selected_month = get_selected_month(params[:select_month])
    @incomes = search(current_user.incomes, @selected_month, "income_date")
    @sum_monthly_incomes = sum_monthly_amount_of_model(@incomes, "income_amount")
    @income = current_user.incomes.build
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end
  
  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
      reflect_monthly_flow(@income.income_date)

      flash[:notice] = '正常に保存しました。'
      redirect_to incomes_path
    else
      @incomes = current_user.incomes.order('created_at desc')
      # @incomes = current_user.incomes.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'incomes'
    end
  end
  
  def destroy
    # 削除前に日付を取得
    income_date = @income.income_date
    @income.destroy

    reflect_monthly_flow(income_date)
    flash[:notice] = '項目を削除しました。'
    redirect_to incomes_path
  end
  
  private
  
  def income_params
    params.require(:income).permit(:title, :income_amount, :income_date)
  end
  
  def correct_user
    @income = current_user.incomes.find_by(id: params[:id])
    unless @income
      redirect_to incomes_path
    end
  end

  def reflect_monthly_flow(income_date)
    incomes = search(current_user.incomes, income_date, "income_date")
    create_or_update_monthly_flow(incomes, "income_amount", income_date)
  end
end
  