class UserTeeTimesController < ApplicationController

  def create
    @tee_time = TeeTime.find_by_id(params[:user_tee_time][:tee_time_id])
    @user = User.find_by_id(params[:user_tee_time][:user_id])
    @user_tee_time = @tee_time.add_user(@user)
    if @user_tee_time
      flash[:alert] = "Success! You're in"
    else
      flash[:alert] = "Sorry, there seems to be an issue"
    end
    redirect_to tee_time_path(@tee_time)
  end

  private

  def user_tee_time_params
    params.require(:user_tee_time).permit(:tee_time_id, :user_id)
  end

end
