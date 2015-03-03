class Sensor < ActiveRecord::Base
  belongs_to :user
  has_many :records

  validates :title, presence: true
  validates :description, presence: true
end
