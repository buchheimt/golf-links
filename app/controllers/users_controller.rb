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
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find_by_id(params[:id])
    authorize @user
  end

  def update
    @user = User.find_by_id(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :pace, :experience, :password, :password_confirmation)
  end

end
