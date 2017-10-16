module ApplicationHelper

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
