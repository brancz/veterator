json.array!(@sensors) do |sensor|
  json.extract! sensor, :name, :unit_id
end
