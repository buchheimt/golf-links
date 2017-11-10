class CommentPolicy < ApplicationPolicy

  def create?
    user && @record.tee_time.users.include?(user)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

end
