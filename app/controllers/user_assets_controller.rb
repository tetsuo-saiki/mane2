class UserAssetsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @user_assets = current_user.user_assets.order('created_at desc')
    @user_asset = current_user.user_assets.build
    @date = Date.today
    @display_monthly_flow = display_monthly_flow(@date)
  end
  
  def create
    @user_asset = current_user.user_assets.build(user_asset_params)
    if @user_asset.save
      flash[:notice] = '正常に保存しました。'
      redirect_to user_assets_path
    else
      @user_assets = current_user.user_assets.order('created_at desc')
      # @user_assets = current_user.user_assets.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'user_assets'
    end
  end
  
  def destroy
    @user_asset.destroy
    flash[:notice] = '項目を削除しました。'
    redirect_to user_assets_path
  end
  
  private
  
  def user_asset_params
    params.require(:user_asset).permit(:title)
  end
  
  def correct_user
    @user_asset = current_user.user_assets.find_by(id: params[:id])
    unless @user_asset
      redirect_to user_assets_path
    end
  end
end
