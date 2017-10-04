class UserTeeTimesController < ApplicationController

  def create
    @user_tee_time = UserTeeTime.new(user_tee_time_params)
    if @user_tee_time.save
      flash[:alert] = "Success! You're in"
    else
      flash[:alert] = "Sorry, there seems to be an issue"
    end
    #binding.pry
    redirect_to tee_time_path(@user_tee_time.tee_time)
  end

  private

  def user_tee_time_params
    params.require(:user_tee_time).permit(:tee_time_id, :user_id)
  end

end
