module TeeTimeHelper

  def tee_time_form_route(tee_time, user, course)
    if user
      [user, tee_time]
    elsif course
      [course, tee_time]
    else
      tee_time
    end
  end

  def show_route(tee_time)
    if params[:controller] == "users"
      user_tee_time_path(params[:id], tee_time)
    elsif params[:controller] == "courses"
      course_tee_time_path(params[:id], tee_time)
    else
      tee_time_path(tee_time)
    end
  end

end
