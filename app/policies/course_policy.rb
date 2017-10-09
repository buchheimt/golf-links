class CoursePolicy < ApplicationPolicy

  def new?
    create?
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    user && user.admin?
  end

end
