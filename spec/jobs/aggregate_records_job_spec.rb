RSpec.describe AggregateRecordsJob, type: :job do
  context 'no previous aggregated records exist' do
    it 'aggregates values by days' do
      sensor = Sensor.create(title: 'test', description: 'test')
      sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
      sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))

      AggregateRecordsJob.perform_now

      record = sensor.records.daily.first
      expect(record.value).to eq 2.0
    end

    it 'aggregates values by months' do
      sensor = Sensor.create(title: 'test', description: 'test')
      sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
      sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))

      AggregateRecordsJob.perform_now

      record = sensor.records.monthly.first
      expect(record.value).to eq 2.0
    end

    it 'aggregates values by years' do
      sensor = Sensor.create(title: 'test', description: 'test')
      sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
      sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))

      AggregateRecordsJob.perform_now

      record = sensor.records.yearly.first
      expect(record.value).to eq 2.0
    end
  end
end
