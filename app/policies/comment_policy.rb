class CommentPolicy < ApplicationPolicy

  def create?
    user && @record.tee_time.users.include?(user)
  end

  def destroy?
    user && @record.tee_time.users.include?(user)
  end

end
