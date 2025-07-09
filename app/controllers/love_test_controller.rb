# app/controllers/love_tests_controller.rb
class LoveTestsController < ApplicationController
  def index
    @recent_calculations = LoveTest.order(created_at: :desc).limit(5)
  end

  def calculate
    if params[:given_name_a].present? && params[:surname_a].present? &&
       params[:given_name_b].present? && params[:surname_b].present?

      given_name_a = params[:given_name_a].strip.capitalize
      surname_a = params[:surname_a].strip.capitalize
      given_name_b = params[:given_name_b].strip.capitalize
      surname_b = params[:surname_b].strip.capitalize

      combined = "#{given_name_a}#{surname_a}#{given_name_b}#{surname_b}".downcase
      @love_percentage = (combined.length * 7 % 100).round(2)

      @love_message = case @love_percentage
                      when 0..20 then "Hmm, maybe just friends?"
                      when 21..50 then "There's a spark, but work might be needed!"
                      when 51..80 then "A strong connection is definitely there!"
                      when 81..100 then "It's a perfect match! ❤️"
                      else "Enter names to find out your compatibility!"
                      end

      @love_test = LoveTest.create(
        given_name_a: given_name_a,
        surname_a: surname_a,
        given_name_b: given_name_b,
        surname_b: surname_b,
        percentage: @love_percentage,
        message: @love_message
      )
    else
      @love_percentage = nil
      @love_message = "Please enter all four names to calculate compatibility."
    end

    @recent_calculations = LoveTest.order(created_at: :desc).limit(5)
    render :index
  end
end
