module ApplicationHelper

  def format_created_at(instance)
    instance.created_at.to_s(:long)
  end

  def check_for_errors(errors, field)
    if errors[field]
      output = "<ul class='error-list'>"
      errors.full_messages_for(field).each {|error| output += "<li class='error-message'>- #{error}</li>"}
      output += "</ul>"
      output.html_safe
    end
  end

end
