class AggregateRecordsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Sensor.all.each do |sensor|
      r = sensor.records.daily.last
      r ||= sensor.records.finest.first
      loop do
        break if r.nil?
        day = r.created_at.beginning_of_day
        avg = sensor.records.avg_on_day(day)
        sensor.records.create(value: avg, created_at: day, granularity: Record.granularities[:daily])
        r = Record.finest.where('created_at > ?', day.end_of_day).first
      end
    end
  end
end
