class TeeTimesController < ApplicationController

  def new
    @tee_time = TeeTime.new
    @user = User.find_by_id(params[:user_id])
  end

  def create
    @tee_time = TeeTime.new(tee_time_params)
    @tee_time.user_tee_times.build(user_id: params[:user_id])
    if @tee_time.save
      redirect_to user_tee_time_path(params[:user_id], @tee_time)
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:user_id])
    @tee_time = TeeTime.find_by_id(params[:id])
  end

  private

  def tee_time_params
    params.require(:tee_time).permit(:course_id, :time)
  end

end
