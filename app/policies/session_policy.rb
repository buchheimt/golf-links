class SessionPolicy < Struct.new(:user, :session)

  def new?
    create?
  end

  def create?
    !user
  end

  def destroy?
    user
  end
end
