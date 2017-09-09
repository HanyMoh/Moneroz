class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin? && user.active?
       can :manage, :all
    elsif !user.admin? && user.active?
    # can [:read, :create, :update, :destroy], Model
      can [:read, :create, :first_term, :sale_cash, :selling_futures, :returned_sale, :barcode, :add_first_term, :add_sale_cash, :add_selling_futures, :add_returned_sale, :add_barcode], Document
      can [:read, :create, :cash_in, :cash_out], Payment
      can [:read, :create, :customer, :fee], Person
      can [:read, :create], Product
      can [:read, :create], Section
      can [:read, :create], Unit
      can [:read         ], User
    end
  end
end
