class Sensor < ActiveRecord::Base
  belongs_to :unit
  has_one :type, through: :unit

  validates :name,
    presence: true

  validates :unit_id,
    presence: true
end
