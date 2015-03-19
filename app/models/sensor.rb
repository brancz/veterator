class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :records, dependent: :delete_all
  enum chart_type: ['linear', 'linear-closed', 'step', 'step-before',
                    'step-after', 'basis', 'basis-open', 'basis-closed',
                    'bundle', 'cardinal', 'cardinal-open', 'cardinal-closed',
                    'monotone']

  validates :title, presence: true
  validates :description, presence: true
end
