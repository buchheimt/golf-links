class UserPolicy < ApplicationPolicy

  def new?
    create?
  end

  def create?
    !user
  end

  def show?
    user
  end

  def edit?
    update?
  end

  def update?
    user && (user.admin? || record.try(:id) == user.id)
  end

  def destroy?
    user && (user.admin? || record.try(:id) == user.id)
  end

end
