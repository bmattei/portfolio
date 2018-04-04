class Ability
  include CanCan::Ability

  def initialize(user)
    if (user.admin)
      can :manage, :all
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    else
      can [:read, :update], AdminUser, id: user.id
      can :manage, Account, admin_user_id: user.id
      can :manage, Ticker
      cannot [:destroy, :update], Ticker
      can :manage, Capture, admin_user_id: user.id
      can :read, Price
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :write, :update], Holding, :account => {admin_user_id: user.id}
      can [:create], Holding

    end

  end
end
        
      
