class Record < ActiveRecord::Base
  belongs_to :sensor

  enum granularity: [ :original, :daily, :monthly, :yearly ]

  validates :value, presence: true

  scope :avg, -> { average(:value) }
  scope :avg_on_day,   ->(day)   { original.where(created_at: day.beginning_of_day..day.end_of_day).avg         }
  scope :avg_in_month, ->(month) { original.where(created_at: month.beginning_of_month..month.end_of_month).avg }
  scope :avg_in_year,  ->(year)  { original.where(created_at: year.beginning_of_year..year.end_of_year).avg     }

  def aggregate_by(granularity)
    method = {
        daily: :avg_on_day,
        monthly: :avg_in_month,
        yearly: :avg_in_year
    }.fetch(granularity)
    sensor.records.public_send(method, created_at)
  end
end
