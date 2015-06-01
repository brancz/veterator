class SensorAccess < ActiveRecord::Base
  belongs_to :sensor
  belongs_to :user
end
