class CoursesController < ApplicationController

  def index
    @courses = Course.all
    #binding.pry
  end

  def show
    @course = Course.find(params[:id])
    #binding.pry
  end

end
