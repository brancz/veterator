class Record < ActiveRecord::Base
  belongs_to :sensor

  validates :value,
    presence: true

  validates :sensor_id,
    presence: true
end
