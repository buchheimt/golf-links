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
        render :edit
      else
        flash[:confirmation] = "Course successfully updated!"
        redirect_to course_path(@course)
      end
    else
      render :edit
    end
  end

  def destroy
    @course = Course.find_by_id(params[:id])
    authorize @course
    flash[:confirmation] = "#{@course.name} has been deleted"
    @course.tee_times.each do |tee_time|
      tee_time.user_tee_times.each {|user_tee_time| user_tee_time.destroy}
      tee_time.destroy
    end
    @course.destroy
    redirect_to courses_path
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
    params.require(:course).permit(:name, :description, :location, :image, :par, :length, :price)
  end

end
