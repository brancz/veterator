json.array!(@sensors) do |sensor|
  json.extract! sensor, :name, :unit_id
  json.url sensor_url(sensor, format: :json)
end
