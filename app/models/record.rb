class Record < ActiveRecord::Base
  belongs_to :sensor

  validates :value, presence: true
end
