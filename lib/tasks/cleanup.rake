task :cleanup_sensors => :environment do
  Sensor.zombies.delete_all
end
