class Sensor < ActiveRecord::Base
  validates :name,
    presence: true

  validates :unit_id,
    presence: true
end
