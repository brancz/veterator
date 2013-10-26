json.array!(@units) do |unit|
  json.extract! unit, :name, :symbol, :type_id
  json.url unit_url(unit, format: :json)
end
