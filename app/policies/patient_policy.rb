class PatientPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    @user.role  == "tutor"
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    @user.role  == "tutor"
  end

  def update?
    @user.role  == "tutor"
  end

  def destroy
    @user.role  == "tutor"
  end

end
