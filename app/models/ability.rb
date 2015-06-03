class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :index, Sensor
    can :show, Sensor do |s|
      s && s.users.include?(user)
    end
    can :new, Sensor
    can :create, Sensor

    is_owner = ->(s) { 
      access = s.sensor_accesses.where(user: user).first
      s && access && access.read_write?
    }
    can :edit, Sensor, &is_owner
    can :update, Sensor, &is_owner
    can :destroy, Sensor, &is_owner
  end
end
