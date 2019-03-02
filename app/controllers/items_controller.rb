class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def index
    @items = current_user.items.order('created_at desc')
    @item = current_user.items.build
    @item_type_id = ItemType.pluck('item_type', 'id')
    @date = Date.today
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      flash[:notice] = '正常に保存しました。'
      redirect_to item_path(@item)
    else
      @items = current_user.items.order('created_at desc')
      # @items = current_user.items.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'items'
    end
  end

  def show
    @item = current_user.items.find_by(id: params[:id])
  end

  def destroy
    @item.destroy
    flash[:notice] = '投稿を削除しました。'
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, :price, :image_url, :date, :item_type_id)
  end

  def correct_user
    @item = current_user.items.find_by(id: params[:id])
    unless @item
      redirect_to items_path
    end
  end
end
