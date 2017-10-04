class UserPolicy < ApplicationPolicy

  def show?
    user
  end

  def edit?
    user.admin? || record.try(:id) == user.id
  end

  def update?
    user.admin? || record.try(:id) == user.id
  end

end
