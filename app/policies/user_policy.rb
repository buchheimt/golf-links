class UserPolicy < ApplicationPolicy

  def new?
    !user
  end

  def create?
    !user
  end

  def show?
    user
  end

  def edit?
    user && (user.admin? || record.try(:id) == user.id)
  end

  def update?
    user && (user.admin? || record.try(:id) == user.id)
  end

end
