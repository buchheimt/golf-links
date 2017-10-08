class UserTeeTimesController < ApplicationController

  def create
    @user_tee_time = UserTee_time.new
    authorize @user_tee_time
    @tee_time = TeeTime.find_by_id(params[:user_tee_time][:tee_time_id])
    @user = User.find_by_id(params[:user_tee_time][:user_id])
    if @tee_time.add_user(@user)
      flash[:confirmation] = "Success! You're in"
    else
      flash[:warning] = "Unable to join"
    end
    redirect_to tee_time_path(@tee_time)
  end

  def destroy
    tee_time = TeeTime.find_by_id(params[:user_tee_time][:tee_time_id])
    @user_tee_time = UserTeeTime.find_by(tee_time_id: params[:user_tee_time][:tee_time_id], user_id: params[:user_tee_time][:user_id])
    authorize @user_tee_time
    @user_tee_time.destroy
    flash[:confirmation] = "Successfully left Tee Time"
    redirect_to tee_time_path(tee_time)
  end

  private

  def user_tee_time_params
    params.require(:user_tee_time).permit(:tee_time_id, :user_id)
  end

end
