if Rails.env.development?
  puts '### Creating Test User ###'
  user = User.create(
    email: 'fbranczyk@gmail.com',
    password: 'testtest',
    password_confirmation: 'testtest',
    confirmed_at: Time.now
  )
  User.create(
      email: 'test@gmail.com',
      password: 'testtest',
      password_confirmation: 'testtest',
      confirmed_at: Time.now
  )
  User.create(
      email: 'admin@example.com',
      password: 'testtest',
      password_confirmation: 'testtest',
      confirmed_at: Time.now,
      admin: true
  )

  puts '### Creating Test Sensor ###'
  sensor = user.sensors.create(
    title: 'Test Title',
    description: 'Test Description'
  )

  puts '### Creating Test Records ###'
  require 'csv'
  require 'date'
  CSV.foreach('db/seed-sensor-records.csv') do |row|
    raw_date, raw_value = row
    sensor.records.create(
      value: raw_value.to_f,
      created_at: Date.parse(raw_date)
    )
  end

  AggregateRecordsJob.perform_now
end
