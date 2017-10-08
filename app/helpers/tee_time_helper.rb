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

  def size_status(tee_time)
    tee_time.users.size == 4 ? " tee-time-full" : ""
  end

  def check_for_course(tee_time)
    params[:controller] != "courses" ? "#{tee_time.course.name} - " : ""

  end

end
