class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def history
    @readings = current_user.user_readings.recent.page(params[:page]).per(10)
  end
  
  def rewards
  @daily_quote = Quote.current
end

  
  def profile
    @user = current_user
    @total_readings = current_user.user_readings.count
    @recent_readings = current_user.user_readings.recent.limit(5)
  end
  
  
end
