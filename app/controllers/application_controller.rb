class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action"
    logged_in? ? redirect_to(user_path(current_user)) : redirect_to(root_path)
  end

end
