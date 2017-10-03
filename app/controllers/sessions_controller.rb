class SessionsController < ApplicationController

  def new
  end

  def create
    if auth
      @user = User.find_or_create_by(email: auth[:info][:email]) do |u|
        u.username = auth['uid']
        u.email = auth['info']['email']
        u.password = SecureRandom.hex
        u.password_confirmation = u.password
        u.save
      end
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      @user = User.find_by(username: params[:user][:username])
      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        render :new
      end
    end
  end

  def destroy
    if logged_in?
      session.delete :user_id
      redirect_to root_path
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
