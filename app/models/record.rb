class Record < ActiveRecord::Base
  belongs_to :sensor

  enum granularity: [ :finest, :daily, :monthly, :yearly ]

  validates :value, presence: true
end
