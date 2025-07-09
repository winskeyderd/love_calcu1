class LoveCalculatorController < ApplicationController
  def index
  end

  def calculate
  @person1_first = params[:person1_first]&.strip&.downcase
  @person1_last = params[:person1_last]&.strip&.downcase
  @person2_first = params[:person2_first]&.strip&.downcase
  @person2_last = params[:person2_last]&.strip&.downcase

  if [@person1_first, @person1_last, @person2_first, @person2_last].any?(&:blank?)
    flash[:error] = "Please fill in all fields"
    redirect_to root_path
    return
  end

  # Record name searches for leaderboard
  NameSearch.record_search(@person1_first, @person1_last)
  NameSearch.record_search(@person2_first, @person2_last)

  @person1_name = "#{@person1_first} #{@person1_last}"
  @person2_name = "#{@person2_first} #{@person2_last}"

  calculator = FlamesCalculator.new(@person1_name, @person2_name)
  @results = calculator.calculate
  
  # Save to user's reading history if logged in
  if user_signed_in?
    current_user.user_readings.create(
      person1_first: @person1_first,
      person1_last: @person1_last,
      person2_first: @person2_first,
      person2_last: @person2_last,
      result: @results[:combined][:result]
    )
  end
  
  render :result
end
  def leaderboard
   @top_names = NameSearch.leaderboard_by_first_name.limit(10)
  end
  
  def about
  end
  
  def contact
  end
end