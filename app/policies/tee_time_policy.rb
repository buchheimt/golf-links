class TeeTimePolicy < ApplicationPolicy

  def new?
    user
  end

  def create?
    user
  end
end
