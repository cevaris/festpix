class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    

    elsif user.customer?
      can :manage, User, :id => user.id
      can [:read, :update], Customer, :id => user.customer.id
      
      can [:create], Event
      can [:read, :update, :destroy], Event, :id => user.customer.events.pluck(:id)

      can [:manage], PhotoSession, :id => PhotoSession.where(event_id: user.customer.events.pluck(:id)).ids



    else
      can [:create], User
      can [:create], Customer
      
      can [:read], PhotoSession
      can [:read], Photo
    end
  end
end
