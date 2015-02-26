class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    belongs_to_user = ->(s) { s && s.user == user }
    can :index, Sensor
    can :show, Sensor, &belongs_to_user
    can :new, Sensor
    can :create, Sensor
    can :edit, Sensor, &belongs_to_user
    can :update, Sensor, &belongs_to_user
    can :destroy, Sensor, &belongs_to_user
  end
end
