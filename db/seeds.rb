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

  when 'production'

end
