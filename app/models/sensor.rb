class Sensor < ActiveRecord::Base
  belongs_to :unit
  has_one :type, through: :unit
	alias :unit_type :type
  has_many :records
  belongs_to :user

  validates :name,
    presence: true

  validates :unit_id,
    presence: true

  validates :user_id,
    presence: true
end
