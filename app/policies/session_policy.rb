class SessionPolicy < Struct.new(:user, :session)

  def new?
    create?
  end

  def create?
    #binding.pry
    !user || !user.uid
  end

  def destroy?
    user
  end
end
