class Sensor < ActiveRecord::Base
  has_and_belongs_to_many :users, -> { uniq }
  has_many :records, dependent: :delete_all
  enum chart_type: ['linear', 'linear-closed', 'step', 'step-before',
                    'step-after', 'basis', 'basis-open', 'basis-closed',
                    'bundle', 'cardinal', 'cardinal-open', 'cardinal-closed',
                    'monotone']

  scope :zombies, -> { joins("LEFT JOIN sensors_users ON sensors_users.sensor_id = sensors.id").where("sensors_users.user_id IS NULL") }

  validates :title, presence: true, length: { in: 1..20 }
  validates :description, presence: true, length: { maximum: 20 }
end
