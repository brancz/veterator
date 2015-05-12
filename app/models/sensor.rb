class Sensor < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :records, dependent: :delete_all
  enum chart_type: ['linear', 'linear-closed', 'step', 'step-before',
                    'step-after', 'basis', 'basis-open', 'basis-closed',
                    'bundle', 'cardinal', 'cardinal-open', 'cardinal-closed',
                    'monotone']

  validates :title, presence: true
  validates :description, presence: true
end
