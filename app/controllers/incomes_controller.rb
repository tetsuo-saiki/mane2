class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    
    @selected_month = get_selected_month(params[:select_month])
    @incomes = search_incomes(@selected_month)
    @sum_monthly_incomes = Income.sum_monthly_income(current_user, @selected_month)

    @income = current_user.incomes.build
    @date = Date.today
  end
  
  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
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
    @income.destroy
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

  def search_incomes(selected_month)
    if selected_month
      current_user.incomes.where('income_date between ? and ?', selected_month.beginning_of_month, selected_month.end_of_month).order('created_at desc')
    else
      current_user.incomes.order('created_at desc')
    end
  end

  def get_selected_month(selected_month)
    if selected_month
      Date.new(selected_month["{}(1i)"].to_i, selected_month["{}(2i)"].to_i)
    else
      nil
    end
  end
end
  