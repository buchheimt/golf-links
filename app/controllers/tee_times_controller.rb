class TeeTimesController < ApplicationController

  def index
    if params[:size]
      @tee_times = TeeTime.size_filter(params[:size], params[:status])
      @sizes = params[:size]
      @status = params[:status]
    else
      @tee_times = TeeTime.active_sort
    end

  end

  def new
    @tee_time = TeeTime.new
    authorize @tee_time
    @user = User.find_by_id(params[:user_id])
    @course = Course.find_by_id(params[:course_id])
  end

  def create
    @tee_time = TeeTime.new(tee_time_params)
    authorize @tee_time
    @tee_time.user_tee_times.build(user_id: session[:user_id])
    if @tee_time.save
      flash[:confirmation] = "Tee time created!"
      if params[:user_id]
        redirect_to user_tee_time_path(params[:user_id], @tee_time)
      elsif params[:course_id]
        redirect_to course_tee_time_path(params[:course_id], @tee_time)
      else
        redirect_to tee_time_path(@tee_time)
      end
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
    params.require(:tee_time).permit(:time, :course_id, course_attributes: [:name, :description, :location, :image, :par, :length, :price])
  end

end
