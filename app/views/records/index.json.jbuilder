json.array!(@records) do |record|
  json.extract! record, :value, :sensor_id
  json.url record_url(record, format: :json)
end
