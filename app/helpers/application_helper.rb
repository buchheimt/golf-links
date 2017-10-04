module ApplicationHelper

  def format_created_at(instance)
    instance.created_at.strftime("%F")
  end

end
