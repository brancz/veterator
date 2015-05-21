class AggregateRecordsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    [:daily, :monthly, :yearly].each do |granularity|
      Sensor.all.each do |sensor|
        r = sensor.records.where('granularity = ?', Record.granularities[granularity]).last
        if r.nil?
          r = sensor.records.original.first
        else
          r.update(value: r.aggregate_by(granularity))
          r = next_record(r, granularity)
        end
        loop do
          break if r.nil?
          time = beginning_of(granularity, r.created_at)
          avg = r.aggregate_by(granularity)
          r.sensor.records.create(value: avg, created_at: time, granularity: Record.granularities[granularity])
          r = next_record(r, granularity)
        end
      end
    end
  end

  def next_record(r, granularity)
    Record.original.where('created_at > ?', end_of(granularity, r.created_at)).first
  end

  def end_of(time_symbol, time)
    method = {
        daily: :end_of_day,
        monthly: :end_of_month,
        yearly: :end_of_year
    }.fetch(time_symbol)
    time.public_send(method)
  end

  def beginning_of(time_symbol, time)
    method = {
        daily: :beginning_of_day,
        monthly: :beginning_of_month,
        yearly: :beginning_of_year
    }.fetch(time_symbol)
    time.public_send(method)
  end
end
