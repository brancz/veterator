# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

temperature = Type.create({name: 'Temperature'})

celsius = Unit.new({name: 'Celsius', symbol: '°C'})
celsius.type = temperature
celsius.save

fahrenheit = Unit.new({name: 'Fahrenheit', symbol: '°F'})
fahrenheit.type = temperature
fahrenheit.save
