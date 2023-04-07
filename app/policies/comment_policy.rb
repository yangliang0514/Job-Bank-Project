class CommentPolicy < ApplicationPolicy
  def create?
    user.company? or user.staff?
  end

  def update?
    user.company? and record.user == user
  end

  def destroy?
    user.company? and record.user == user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
