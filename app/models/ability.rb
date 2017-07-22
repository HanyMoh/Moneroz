class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin? && user.active?
       can :manage, :all
    elsif !user.admin? && user.active?
    # can [:read, :create, :update, :destroy], Model
      can [:read, :create, :cash_in, :cash_out], Payment
      can [:read, :create, :customer, :fee], Person
      can [:read, :create], Product
      can [:read, :create], Section
      can [:read, :create], Unit
      can [:read         ], User
    end
  end
end
