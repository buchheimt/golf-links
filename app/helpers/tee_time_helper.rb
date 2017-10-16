module TeeTimeHelper

  def format_tee_time(tee_time)
    tee_time.time.strftime("%A %b %e, %Y | %l:%M %p")
  end

  def format_tee_time_long(tee_time)
    tee_time.time.strftime("<h4>%A | %l:%m %p</h4><h4>%B %e, %Y</h4>").html_safe
    tee_time.time.strftime("<h4>%B %e, %Y</h4><h4>%A | %l:%M %p</h4>").html_safe
  end

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

  def group_description(tee_time)
    "<strong>Size:</strong> #{tee_time.group_size}/4 | <strong>Avg. Pace:</strong> #{tee_time.avg_pace} | <strong>Avg. Experience:</strong> #{tee_time.avg_experience}".html_safe
  end

end
