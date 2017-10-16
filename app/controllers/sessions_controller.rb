class SessionsController < ApplicationController

  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?
    if auth
      from_facebook
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

  def from_facebook
    if !auth['info']['email']
      facebook_no_email
    elsif logged_in?
      facebook_connect
    elsif user = User.find_by(email: auth['info']['email'])
      facebook_email_found(user)
    else
      facebook_new_email
    end
  end


  def facebook_connect
    if User.find_by(uid: auth['uid'])
      facebook_already_connected
    else
      facebook_valid_connect
    end
  end

  def facebook_email_found(user)
    if user.uid.nil?
      facebook_not_connected
    elsif user.uid != auth[:uid]
      facebook_already_connected
    else
      facebook_valid_login(user)
    end
  end

  def facebook_new_email
    user = User.new_from_omniauth(auth)
    if user.valid?
      facebook_valid_login(user)
    else
      facebook_no_email
    end
  end


  def facebook_valid_connect
    current_user.connect_from_omniauth(auth)
    facebook_success
  end

  def facebook_valid_login(user)
    session[:user_id] = user.id
    facebook_success
  end

  def facebook_success
    flash[:confirmation] = "Welcome, #{current_user.username}!"
    redirect_to user_path(current_user)
  end

  def facebook_already_connected
    flash[:warning] = "This Facebook account is already associated with a user"
    redirect_to root_path
  end

  def facebook_not_connected
    flash[:warning] = "The email associated with this Facebook account is unconnected. Login directly and connect your account through your profile"
    redirect_to root_path
  end

  def facebook_no_email
    flash[:warning] = "Your FB does not have a valid email, check your contact info"
    redirect_to user_path(user)
  end

end
