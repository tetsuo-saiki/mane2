class HomeController < ApplicationController
  include Common

  def index
    @date = Date.today
    @monthly_flow = return_monthly_flow(@date)
  end
end
