json.array!(@records) do |record|
  json.extract! record, :created_at, :value
end
