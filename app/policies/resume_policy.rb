class ResumePolicy < ApplicationPolicy
  def create?
    @user.role == "user" || @user.role == "vip"
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def like?
    user.company?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
