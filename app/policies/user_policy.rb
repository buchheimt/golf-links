class UserPolicy < ApplicationPolicy

  def edit?
    user.admin? || record.try(:id) == user.id
  end

end
