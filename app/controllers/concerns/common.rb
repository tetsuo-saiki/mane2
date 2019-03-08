module Common
  # 選択月のモデル取得 selected_month = "2019-03-01" (Date型)
  def search(model, selected_month, search_column)
    if selected_month
      model.where("#{search_column} between ? and ?", selected_month.beginning_of_month, selected_month.end_of_month).order('created_at desc')
    else
      model.order('created_at desc')
    end
  end

  # date_selectの選択月取得 selected_month = {"{}(1i)"=>"2019", "{}(2i)"=>"3", "{}(3i)"=>"1"}
  def get_selected_month(selected_month)
    if selected_month
      Date.new(selected_month["{}(1i)"].to_i, selected_month["{}(2i)"].to_i)
    else
      nil
    end
  end

  # 各モデルの選択月の値合計
  def sum_monthly_amount_of_model(model_object, sum_column)
    model_object.sum(sum_column)
  end

  # monthly_flow テーブルに月のフローを登録
  def create_or_update_monthly_flow(model_object, sum_column, selected_month)
    if selected_month
      monthly_sum = sum_monthly_amount_of_model(model_object, sum_column)
      target_column = "#{sum_column}_sum"
      monthly_flow = current_user.monthly_flows.where(["year = ? and month = ?", selected_month.year, selected_month.month]).first
      if monthly_flow
        monthly_flow.send("#{target_column}=", monthly_sum) # send にて動的に attributes に値を代入
        monthly_flow.save!
      else
        monthly_flow = current_user.monthly_flows.build
        monthly_flow.send("#{target_column}=", monthly_sum) # send にて動的に attributes に値を代入
        monthly_flow.year = selected_month.year
        monthly_flow.month = selected_month.month
        monthly_flow.save!
      end
    end
  end

  def return_monthly_flow(selected_month)
    monthly_flow = current_user.monthly_flows.where(["year = ? and month = ?", selected_month.year, selected_month.month]).first
    monthly_flow.income_amount_sum - monthly_flow.price_sum - monthly_flow.credit_withdrawal_sum - monthly_flow.debt_withdrawal_sum
  end

  private

end