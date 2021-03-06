class TeeTimesController < ApplicationController

  def index
    if params[:user_id]
      @user = User.find_by_id(params[:user_id])
      @tee_times = @user.tee_times.sort {|a, b| a.time <=> b.time}
    elsif params[:size]
      @tee_times = TeeTime.size_filter(params[:size], params[:status])
      @sizes = params[:size]
      @status = params[:status]
    else
      @tee_times = TeeTime.active_sort
    end
    respond_to do |f|
      f.html {render :index}
      f.json {render json: @tee_times, include: 'course'}
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
      @course = Course.find_by_id(params[:course_id])
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:user_id])
    @tee_time = TeeTime.find_by_id(params[:id])
    @comments = @tee_time.comments
  end

  private

  def tee_time_params
    params.require(:tee_time).permit(
      :time,
      :course_id,
      user_tee_times_attributes: [:guest_count, :user_id],
      course_attributes: [:name, :description, :location, :image, :par, :length, :price]
    )
  end

end
