class AggregateRecordsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    [:daily, :monthly, :yearly].each do |granularity|
      Sensor.all.each do |sensor|
        r = sensor.records.where('granularity = ?', Record.granularities[granularity]).last
        r ||= sensor.records.original.first
        loop do
          break if r.nil?
          time = beginning_of(r.created_at, granularity)
          avg = r.aggregate_by(granularity)
          sensor.records.create(value: avg, created_at: time, granularity: Record.granularities[granularity])
          r = Record.original.where('created_at > ?', end_of(time, granularity)).first
        end
      end
    end
  end

  def end_of(time, time_symbol)
    method = {
        daily: :end_of_day,
        monthly: :end_of_month,
        yearly: :end_of_year
    }[time_symbol]
    time.public_send(method)
  end

  def beginning_of(time, time_symbol)
    method = {
        daily: :beginning_of_day,
        monthly: :beginning_of_month,
        yearly: :beginning_of_year
    }[time_symbol]
    time.public_send(method)
  end
end
