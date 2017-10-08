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

  private

  def course_params
    params.require(:course).permit(:name, :description, :location)
  end

end
