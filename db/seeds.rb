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
celsius = Unit.create({name: 'Celsius', symbol: '°C', type_id: temperature.id})
fahrenheit = Unit.create({name: 'Fahrenheit', symbol: '°F', type_id: temperature.id})
kelvin = Unit.create({name: 'Kelvin', symbol: 'K', type_id: temperature.id})

length = Type.create({name: 'Length'})
meter = Unit.create({name: 'Meter', symbol: 'm', type_id: length.id})

mass = Type.create({name: 'Mass'})
kilogram = Unit.create({name: 'Gram', symbol: 'g', type_id: mass.id})

time = Type.create({name: 'Time'})
second = Unit.create({name: 'Second', symbol: 's', type_id: time.id})

electric_current = Type.create({name: 'Electric current'})
ampere = Unit.create({name: 'Ampere', symbol: 'A', type_id: electric_current.id})

amount_of_substance = Type.create({name: 'Amount of substance'})
mole = Unit.create({name: 'Mole', symbol: 'mol', type_id: amount_of_substance.id})

luminous_intensity = Type.create({name: 'Luminous intensity'})
candela = Unit.create({name: 'Candela', symbol: 'cd', type_id: luminous_intensity.id})

angle = Type.create({name: 'Angle'})
radiant = Unit.create({name: 'Radiant', symbol: 'rad', type_id: angle.id})

solid_angle = Type.create({name: 'Solid anglee'})
steradian = Unit.create({name: 'Sterdian', symbol: 'sr', type_id: solid_angle.id})

frequency = Type.create({name: 'Frequency'})
hertz = Unit.create({name: 'Hertz', symbol: 'Hz', type_id: frequency.id})

force = Type.create({name: 'Force'})
newton = Unit.create({name: 'Newton', symbol: 'N', type_id: force.id})

pressure = Type.create({name: 'Pressure'})
pascal = Unit.create({name: 'Pascal', symbol: 'Pa', type_id: pressure.id})

work = Type.create({name: 'Work'})
joule = Unit.create({name: 'Joule', symbol: 'J', type_id: work.id})

power = Type.create({name: 'Power'})
watt = Unit.create({name: 'Watt', symbol: 'W', type_id: power.id})

electric_charge = Type.create({name: 'Electric charge'})
coulomb = Unit.create({name: 'Coulomb', symbol: 'C', type_id: electric_charge.id})

voltage = Type.create({name: 'Voltage'})
volt = Unit.create({name: 'Volt', symbol: 'V', type_id: voltage.id})

capacitance = Type.create({name: 'Capacitance'})
farad = Unit.create({name: 'Farad', symbol: 'F', type_id: capacitance.id})

electrical_resistance = Type.create(name: 'Electrical resistance')
ohm = Unit.create(name: 'Ohm', symbol: 'Ω', type_id: electrical_resistance.id)

electric_conductance = Type.create(name: 'Electric conductance')
siemens = Unit.create(name: 'Siemens', symbol: 'S', type_id: electric_conductance.id)

magnetic_flux = Type.create(name: 'Magnetic flux')
weber = Unit.create(name: 'Weber', symbol: 'Wb', type_id: magnetic_flux.id)

magnetic_flux_density = Type.create(name: 'Magnetic flux density')
tesla = Unit.create(name: 'Tesla', symbol: 'T', type_id: magnetic_flux_density.id)

inductance = Type.create(name: 'Inductance')
henry = Unit.create(name: 'Henry', symbol: 'H', type_id: inductance.id)

luminous_flux = Type.create(name: 'Luminous flux')
lumen = Unit.create(name: 'Lumen', symbol: 'lm', type_id: luminous_flux.id)

illuminance = Type.create(name: 'Illuminance')
lux = Unit.create(name: 'Lux', symbol: 'lx', type_id: illuminance.id)

radioactivity = Type.create(name: 'Radioactivity')
becquerel = Unit.create(name: 'Becquerel', symbol: 'Bq', type_id: radioactivity.id)

absorbed_dose = Type.create(name: 'Absorbed dose')
gray = Unit.create(name: 'Gray', symbol: 'Gy', type_id: absorbed_dose.id)

ionizing_radiation_dose = Type.create(name: 'Ionizing radiation dose')
sievert = Unit.create(name: 'Sievert', symbol: 'Sv', type_id: ionizing_radiation_dose.id)

catalytic_activity = Type.create(name: 'Catalytic activity')
katal = Unit.create(name: 'Katal', symbol: 'kat', type_id: catalytic_activity.id)

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
