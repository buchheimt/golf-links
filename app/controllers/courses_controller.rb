class CoursesController < ApplicationController

  def index
    @courses = Course.all
    respond_to do |f|
      f.html {render :index}
      f.json {render json: @courses}
  end

  def new
    @course = Course.new
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    if @course.save
      flash[:confirmation] = "Course successfully added!"
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
    @tee_times = @course.active_tee_times
    end
  end

  def edit
    @course = Course.find_by_id(params[:id])
    authorize @course
  end

  def update
    @course = Course.find_by_id(params[:id])
    authorize @course
    last_update = @course.updated_at
    if @course.update(course_params)
      if last_update == @course.updated_at
        flash[:warning] = "No changes to update"
      else
        flash[:confirmation] = "Course successfully updated!"
      end
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def destroy
    course = Course.find_by_id(params[:id])
    authorize course
    flash[:confirmation] = "#{course.name} has been deleted"
    course.tee_times.each do |tee_time|
      tee_time.user_tee_times.destroy_all
      tee_time.destroy
    end
    course.destroy
    redirect_to courses_path
  end

  def favorite_course
    @user = User.find_by_id(params[:id])
    if !@user || @user.courses.empty?
      redirect_to root_path
    else
      @course = @user.favorite_course
      @tee_times = @course.active_tee_times
      render :show
    end
  end

  def most_popular
    @course = Course.most_popular
    @tee_times = @course.active_tee_times
    render :show
  end

  def prev
    @course = Course.find_prev_course(params[:id])
    render json: @course
  end

  def next
    @course = Course.find_next_course(params[:id])
    render json: @course
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :location, :image, :par, :length, :price)
  end

end
