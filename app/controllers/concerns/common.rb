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

  # 選択月の値合計
  def sum_monthly_amount(model_object, sum_column)
    model_object.sum(sum_column)
  end
end