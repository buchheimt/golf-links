class TeeTimesController < ApplicationController

  def index
    @tee_times = TeeTime.all
  end

  def new
    @tee_time = TeeTime.new
    @user = User.find_by_id(params[:user_id])
    @course = Course.find_by_id(params[:course_id])
  end

  def create
    @tee_time = TeeTime.new(tee_time_params)
    @tee_time.user_tee_times.build(user_id: session[:user_id])
    if @tee_time.save
      if params[:user_id]
        redirect_to user_tee_time_path(params[:user_id], @tee_time)
      elsif params[:course_id]
        redirect_to course_tee_time_path(params[:course_id], @tee_time)
      else
        redirect_to tee_time_path(@tee_time)
      end
    else
      binding.pry
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:user_id])
    @tee_time = TeeTime.find_by_id(params[:id])
  end

  def edit

  end

  def update

  end

  private

  def tee_time_params
    params.require(:tee_time).permit(:course_id, :time, course_attributes: [:name, :description, :location])
  end

end
