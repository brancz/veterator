class AggregateRecordsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Record.where("granularity <> ?", Record.granularities[:finest]).delete_all
    Sensor.all.each do |sensor|
      daily = {}
      monthly = {}
      yearly = {}
      sensor.records.each do |record|
        date = record.created_at.to_date
        daily[date] << record.value
        monthly[date.beginning_of_month] << record.value
        yearly[date.beginning_of_year] << record.value
      end

      [daily, monthly, yearly].each do |g| 
        g.each do |time, value|
          values = daily[time]
          avg = values.reduce(BigDecimal.new(0), :+) / values.length
          puts "#{time}: #{avg}"
        end
      end
    end
  end
end
