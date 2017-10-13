class SessionsController < ApplicationController

  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?
    if auth
      @user = User.find_or_create_by(uid: auth['uid']) do |u|
        u.username = auth['info']['name'].split(" ")[0].capitalize + auth[:info][:name].split(" ")[1][0] + auth[:uid][0...2]
        u.email = auth['info']['email']
        u.uid = auth['uid']
        u.password = SecureRandom.hex
        u.password_confirmation = u.password
        u.image = auth['info']['image'] + "?type=large"
        u.save
      end
      session[:user_id] = @user.id
      flash[:confirmation] = "Welcome, #{@user.username}!"
      redirect_to user_path(@user)
    else
      @user = User.find_by(username: params[:user][:username])
      if @user && @user.authenticate(params[:user][:password])
        flash[:confirmation] = "Welcome back, #{@user.username}!"
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash[:warning] = "Invalid combination of Username and Password"
        redirect_to signin_path
      end
    end
  end

  def destroy
    authorize :session, :destroy?
    session.delete :user_id
    flash[:confirmation] = "Logout successful"
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
