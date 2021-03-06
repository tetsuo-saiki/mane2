class ItemsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def index
    @selected_month = get_selected_month(params[:select_month])
    @item_entity = search(current_user.items, @selected_month, "date")
    @items = @item_entity.order('date desc').order('created_at desc').paginate(page: params[:page], per_page: 5)
    @sum_monthly_items = sum_monthly_amount_of_model(@item_entity, "price")

    @item = current_user.items.build
    @item_type_id = current_user.item_types.pluck('item_type', 'id')

    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      reflect_monthly_flow(@item.date)

      flash[:notice] = '正常に保存しました。'
      redirect_to item_path(@item)
    else
      @items = current_user.items.order('date desc').paginate(page: params[:page], per_page: 5)
      flash.now[:alert] = '保存に失敗しました。'
      render 'items'
    end
  end

  def show
    @item = current_user.items.find_by(id: params[:id])
  end

  def destroy
    # 削除前に日付を取得
    date = @item.date
    @item.destroy

    reflect_monthly_flow(date)

    flash[:notice] = '項目を削除しました。'
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, :price, :image_url, :date, :item_type_id, :use_credit)
  end

  def correct_user
    @item = current_user.items.find_by(id: params[:id])
    unless @item
      redirect_to items_path
    end
  end

  def reflect_monthly_flow(date)
    items = search(current_user.items, date, "date")
    create_or_update_monthly_flow(items, "price", date)
  end
end
