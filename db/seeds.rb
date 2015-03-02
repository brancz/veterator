puts '### Test User ###'
user = User.create(
  email: 'fbranczyk@gmail.com',
  password: 'testtest',
  password_confirmation: 'testtest',
  confirmed_at: Time.now
)

puts '### Test Sensor ###'
sensor = user.sensors.create(
  title: 'Test Title',
  description: 'Test Description'
)

puts '### Test Records (365 Records) ###'
1.year.ago.to_date.step(Time.now.to_date).each.with_index do |date, index|
  sensor.records.create(value: index+50, created_at: date)
end

