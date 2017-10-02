class TeeTimesController < ApplicationController

  def show
    @user = User.find_by_id(params[:user_id])
    @tee_time = TeeTime.find_by_id(params[:id])
  end

end
