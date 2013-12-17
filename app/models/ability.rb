class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
		elsif user.role? :user
			### Sensors
			can :create, Sensor
      can :read, Sensor do |s|
				s && s.user == user
			end
			can :update, Sensor do |s|
				s && s.user == user
			end
			can :destroy, Sensor do |s|
				s && s.user == user
			end
			### Authentication Tokens
			can :create, AuthenticationToken
			can :update, AuthenticationToken do |t|
				t && t.user == user
			end
			can :destroy, AuthenticationToken do |t|
				t && t.user == user
			end
			### Records
			can :create, Record
			can :destroy, Record do |r|
				r.user == user
			end
			### Units & Types
			### A user cannot manage units or types
    end
  end
end
