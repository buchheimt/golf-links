class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :verify_user

  def current_user
    @user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def verify_user
    if !logged_in?
      redirect_to root_path
    elsif current_user.id != params[:id].to_i
      #binding.pry
      redirect_to user_path(params[:id])
    end
  end

end
