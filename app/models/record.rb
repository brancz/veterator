class Record < ActiveRecord::Base
  belongs_to :sensor

  enum granularity: [ :finest, :daily, :monthly, :yearly ]

  validates :value, presence: true

  default_scope { where(granularity: granularities[:finest]) }
  scope :avg, -> { average(:value) }
  scope :avg_on_day,   ->(day)   { where(created_at: day.beginning_of_day..day.end_of_day).avg         }
  scope :avg_in_month, ->(month) { where(created_at: month.beginning_of_month..month.end_of_month).avg }
  scope :avg_in_year,  ->(year)  { where(created_at: year.beginning_of_year..year.end_of_year).avg     }
end
