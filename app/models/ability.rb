class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :index, Sensor
    can :new, Sensor
    can :create, Sensor

    can :show, Sensor do |s|
      s && s.users.include?(user)
    end

    read_write = ->(s) { 
      access = s.sensor_accesses.where(user: user).first
      s && access && access.read_write?
    }
    can :edit, Sensor, &read_write
    can :update, Sensor, &read_write
    can :destroy, Sensor, &read_write
  end
end
