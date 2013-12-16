class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
    else
			can :create, Sensor
      can :read, Sensor do |s|
				s && s.user == user
			end
			can :update Sensor do |s|
				s && s.user == user
			end
			can :destroy Sensor do |s|
				s && s.user == user
			end
    end
  end
end
