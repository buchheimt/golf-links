module UserHelper

  def format_created_at(user)
    user.created_at.strftime("%b %e, %Y")
  end

end
