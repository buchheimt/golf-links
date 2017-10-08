class UserTeeTimePolicy < Struct.new(:user, :session)

  def create?
    user
  end

end
