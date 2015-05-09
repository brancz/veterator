class Granularity
  def self.select_by_time_range(from, to)
    # these calculartions are not very exact but are good enough to select a granularity
    time_in_seconds = (to.to_time - from.to_time)
    time_in_days = time_in_seconds / (3600 * 24)
    time_in_months = time_in_days / 30
    time_in_years = time_in_months / 12
    granularity = :original
    # keys are from the granularity enum in Record model
    time = {
      daily: time_in_days,
      monthly: time_in_months,
      yearly: time_in_years
    }
    time.each do |key, value|
      granularity = key unless value < 1.0
    end
    granularity
  end
end
