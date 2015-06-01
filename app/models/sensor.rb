class Sensor < ActiveRecord::Base
  has_many :sensor_accesses
  has_many :users, -> { uniq }, through: :sensor_accesses
  has_many :records, dependent: :delete_all
  enum chart_type: ['linear', 'linear-closed', 'step', 'step-before',
                    'step-after', 'basis', 'basis-open', 'basis-closed',
                    'bundle', 'cardinal', 'cardinal-open', 'cardinal-closed',
                    'monotone']

  scope :zombies, -> { joins("LEFT JOIN sensor_accesses ON sensor_accesses.sensor_id = sensors.id").where("sensor_accesses.user_id IS NULL") }

  validates :title, presence: true, length: { in: 1..20 }
  validates :description, presence: true, length: { maximum: 20 }
end
