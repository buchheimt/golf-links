class UsersController < ApplicationController

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      session[:user_id] = @user.id
      flash[:confirmation] = "Welcome, #{@user.username}!"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    @tee_times = @user.active_tee_times
  end

  def edit
    @user = User.find_by_id(params[:id])
    authorize @user
  end

  def update
    @user = User.find_by_id(params[:id])
    last_update = @user.updated_at
    authorize @user
    if @user.update(user_params)
      if last_update == @user.updated_at
        flash[:warning] = "No changes to update"
        redirect_to user_path(@user)
      else
        flash[:confirmation] = "Update successful!"
        redirect_to user_path(@user)
      end
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    authorize @user
    session.delete(:user_id) if session[:user_id] == @user.id
    flash[:confirmation] = "#{@user.username} has been deleted"
    @user.user_tee_times.destroy_all
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :pace, :experience, :role, :image, :password, :password_confirmation)
  end

end
