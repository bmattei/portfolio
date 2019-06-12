class Ability
  include CanCan::Ability

  def initialize(admin_user)
    if (admin_user.admin)
      can :manage, :all
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    else
      can :read, SsFactor
      can [:read, :update], AdminUser, id: admin_user.id
      can :manage, Account, admin_user_id: admin_user.id
      can :manage, Ticker
      cannot [:destroy, :update], Ticker
      can :manage, Capture, admin_user_id: admin_user.id
      can :read, Price
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
      can [:read, :write, :update, :destroy], Holding, :account => {admin_user_id: admin_user.id}
      can :manage, Earning, :user => {admin_user_id: admin_user.id}
      can [:create], Holding
      can :manage, User, admin_user_id: admin_user.id
    end

  end
end
        
      
