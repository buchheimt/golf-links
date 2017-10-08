class UserTeeTimePolicy < ApplicationPolicy

  def create?
    user
  end

  def destroy?
    user && @record.tee_time.users.include?(user)
  end

end
