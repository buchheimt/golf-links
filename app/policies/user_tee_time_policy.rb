class UserTeeTimePolicy < ApplicationPolicy

  def create?
    user
  end

  def update?
    user && @record.user == user
  end

  def destroy?
    user && @record.user == user
  end

end
