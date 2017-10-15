class SessionsController < ApplicationController

  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?
    if auth
      if !auth['info']['email']
        flash[:warning] = "Your FB does not have a valid email, check your contact info"
        redirect_to root_path
      elsif @user = current_user
        if User.find_by(uid: auth['uid'])
          flash[:warning] = "This Facebook account is associated with another user"
          redirect_to root_path
        else
          @user.uid = auth['uid']
          @user.image = auth['info']['image'] + "?type=large"
          @user.save
          flash[:confirmation] = "You're connected!"
          redirect_to user_path(@user)
        end
      elsif @user = User.find_by(email: auth['info']['email'])
        if @user.uid.nil?
          @user.uid = auth['uid']
          @user.image = auth['info']['image'] + "?type=large"
          @user.save
          flash[:confirmation] = "Welcome, #{@user.username}!"
          redirect_to user_path(@user)
        elsif @user.uid != auth[:uid]
          flash[:warning] = "This Facebook email is associated with another user"
          redirect_to root_path
        else
          flash[:confirmation] = "Welcome, #{@user.username}!"
          session[:user_id] = @user.id
          redirect_to user_path(@user)
        end
      else
        @user = User.find_or_create_by(uid: auth['uid']) do |u|
          u.username = auth['info']['name'].split(" ")[0].capitalize + auth[:info][:name].split(" ")[1][0] + auth[:uid][0...2]
          u.email = auth['info']['email']
          u.uid = auth['uid']
          u.password = SecureRandom.hex
          u.password_confirmation = u.password
          u.image = auth['info']['image'] + "?type=large"
          u.save
        end
        if @user.valid?
          flash[:confirmation] = "Welcome, #{@user.username}!"
          session[:user_id] = @user.id
          redirect_to user_path(@user)
        else
          flash[:warning] = "Sorry, your FB settings"
          redirect_to user_path(@user)
        end
      end
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
