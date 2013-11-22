# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

case Rails.env
  when 'development'

    user = User.new({username: 'test', email: 'test@example.com', password: 'test', password_confirmation: 'test'})
    user.confirmation_sent_at = Time.now
    user.skip_confirmation!
    user.save!(:validate => false)

    temperature = Type.create({name: 'Temperature'})

    celsius = Unit.new({name: 'Celsius', symbol: '°C'})
    celsius.type = temperature
    celsius.save

    fahrenheit = Unit.new({name: 'Fahrenheit', symbol: '°F'})
    fahrenheit.type = temperature
    fahrenheit.save

    server = Sensor.new({name: 'Server'})
    server.unit = celsius
    server.user = user
    server.save

		t = Time.now
		Record.create({value: 1.0, sensor: server, created_at: t + 1.minute})
		Record.create({value: 1.5, sensor: server, created_at: t + 2.minute})
		Record.create({value: 2.0, sensor: server, created_at: t + 3.minute})
		Record.create({value: 1.8, sensor: server, created_at: t + 4.minute})
		Record.create({value: 1.3, sensor: server, created_at: t + 5.minute})
		Record.create({value: 1.4, sensor: server, created_at: t + 6.minute})
		Record.create({value: 1.9, sensor: server, created_at: t + 7.minute})

  when 'production'

end
