class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    @tee_times = TeeTime.course_date_sort(@course)
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :location)
  end

end
