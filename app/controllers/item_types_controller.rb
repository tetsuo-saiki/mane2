class ItemTypesController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def index
    @item_type = current_user.item_types.build
    @item_types = current_user.item_types.order('created_at desc')
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end

  def create
    @item_type = current_user.item_types.build(item_type_params)
    if @item_type.save
      flash[:notice] = '正常に保存しました。'
      redirect_to item_types_path
    else
      @item_types = current_user.item_types.order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'item_types'
    end
  end

  def destroy
    @item_type.destroy
    flash[:notice] = '項目を削除しました。'
    redirect_to item_types_path
  end

  private

  def item_type_params
    params.require(:item_type).permit(:item_type)
  end

  def correct_user
    @item_type = current_user.item_types.find_by(id: params[:id])
    unless @item_type
      redirect_to item_types_path
    end
  end
end
