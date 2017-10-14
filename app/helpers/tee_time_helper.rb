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

  def tee_time_status(tee_time)
    tee_time.group_size == 4 || tee_time.time.to_date < Time.now.to_date ? " tee-time-unjoinable" : ""
  end

  def check_for_course(tee_time)
    params[:controller] != "courses" ? "<h4>#{tee_time.course.name}</h4>".html_safe : ""
  end

  def get_user_tee_time(tee_time, user)
    user_tee_time = UserTeeTime.find_by(tee_time_id: tee_time.id, user_id: user.id)
    user_tee_time.id if user_tee_time
  end

end
