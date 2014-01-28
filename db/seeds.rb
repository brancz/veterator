# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_role = Role.create(name: 'user')
admin_role = Role.create(name: 'admin')

temperature = Type.create({name: 'Temperature'})

celsius = Unit.new({name: 'Celsius', symbol: '°C'})
celsius.type = temperature
celsius.save

fahrenheit = Unit.new({name: 'Fahrenheit', symbol: '°F'})
fahrenheit.type = temperature
fahrenheit.save

case Rails.env
  when 'development'

		admin_user = User.new({username: 'testadmin', email: 'admin@example', password: 'test', password_confirmation: 'test'})
		admin_user.confirmation_sent_at = Time.now
		admin_user.roles << user_role << admin_role
		admin_user.skip_confirmation!
		admin_user.save!(validate: false)

    user = User.new({username: 'test', email: 'test@example.com', password: 'test', password_confirmation: 'test'})
    user.confirmation_sent_at = Time.now
		user.roles << user_role
    user.skip_confirmation!
    user.save!(:validate => false)

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
		admin_user = User.new({username: 'admin', email: 'admin@localhost.localdomain', password: 'q1w2f3p4', password_confirmation: 'q1w2f3p4'})
		admin_user.confirmation_sent_at = Time.now
		admin_user.roles << user_role << admin_role
		admin_user.skip_confirmation!
		admin_user.save!(validate: false)

end
