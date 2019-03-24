class PdfsController < ApplicationController
  include Common

  def index
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
    
    @start = params[:select_date_start] ? params[:select_date_start]['{}'] : @date.strftime("%Y-%m-%d")
    @end = params[:select_date_end] ? params[:select_date_end]['{}'] : @date.strftime("%Y-%m-%d")
    if params[:include_credit]['flg'] === '1'
      @sum_items = current_user.items.where("date between ? and ?", @start, @end).group(:item_type_id).select("item_type_id, sum(price) as sum_price")
    else
      @sum_items = current_user.items.where("date between ? and ?", @start, @end).where("use_credit = 0").group(:item_type_id).select("item_type_id, sum(price) as sum_price")
    end
  end
end
