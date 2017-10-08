class CoursesController < ApplicationController

  def index
    @courses = Course.all
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
    @tee_times = TeeTime.course_date_sort(@course)
  end

  def favorite_course
    @user = User.find_by_id(params[:id])
    if !@user || @user.courses.empty?
      redirect_to root_path
    else
      @course = @user.favorite_course
      @tee_times = TeeTime.course_date_sort(@course)
      render :show
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :location)
  end

end
