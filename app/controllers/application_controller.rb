class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :public_controller_action?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_user_streak, if: :user_signed_in?

  
  # Redirect after login
  def after_sign_in_path_for(resource)
    profile_path
  end

  # Redirect after sign up
  def after_sign_up_path_for(resource)
  profile_path # or root_path if you want to go to main
end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
  end

  private

  def update_user_streak
    return if current_user.last_login_date == Date.current
    current_user.update_login_streak
  end

  def public_controller_action?
    public_routes = [
      { controller: 'love_calculator', action: 'index' },
      { controller: 'love_calculator', action: 'calculate' },
      { controller: 'love_calculator', action: 'leaderboard' },
      { controller: 'love_calculator', action: 'about' },
      { controller: 'love_calculator', action: 'contact' }
    ]

    public_routes.any? do |route|
      route[:controller] == controller_name && route[:action] == action_name
    end
  end
end
