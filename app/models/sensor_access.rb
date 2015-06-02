class SensorAccess < ActiveRecord::Base
  belongs_to :sensor
  belongs_to :user

  enum access_level: [:owner, :read_only]
end
