module ApplicationHelper

  def format_created_at(user)
    user.created_at.strftime("%b %e, %Y")
  end

  def format_tee_time(tee_time)
    tee_time.time.strftime("%A %b %e, %Y | %l:%m %p")
  end

  def format_tee_time_long(tee_time)
    tee_time.time.strftime("<h4>%A | %l:%m %p</h4><h4>%B %e, %Y</h4>").html_safe
    tee_time.time.strftime("<h4>%B %e, %Y</h4><h4>%A | %l:%m %p</h4>").html_safe
  end

  def check_for_errors(errors, fields)
    if fields.any? {|field| errors[field]}
      output = "<ul class='error-list'>"
      fields.each do |field|
        errors.full_messages_for(field).each {|error| output += "<li class='error-message'>- #{error}</li>"}
      end
      output += "</ul>"
      output.html_safe
    end
  end

end
