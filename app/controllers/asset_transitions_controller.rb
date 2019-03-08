class AssetTransitionsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def index
    @asset_transitions = current_user.asset_transitions.order('created_at desc')
    @asset_transition = current_user.asset_transitions.build
    @user_asset_id = UserAsset.pluck('title', 'id')
    @date = Date.today
    @monthly_flow = return_monthly_flow(@date)
  end
  
  def create
    @asset_transition = current_user.asset_transitions.build(asset_transition_params)
    if @asset_transition.save
      flash[:notice] = '正常に保存しました。'
      redirect_to asset_transitions_path
    else
      @asset_transitions = current_user.asset_transitions.order('created_at desc')
      # @asset_transitions = current_user.asset_transitions.page(params[:page]).per(10).order('created_at desc')
      flash.now[:alert] = '保存に失敗しました。'
      render 'asset_transitions'
    end
  end
  
  def destroy
    @asset_transition.destroy
    flash[:notice] = '項目を削除しました。'
    redirect_to asset_transitions_path
  end
  
  private
  
  def asset_transition_params
    params.require(:asset_transition).permit(:asset_amount, :user_asset_id, :date)
  end
  
  def correct_user
    @asset_transition = current_user.asset_transitions.find_by(id: params[:id])
    unless @asset_transition
      redirect_to asset_transitions_path
    end
  end
end
  
  