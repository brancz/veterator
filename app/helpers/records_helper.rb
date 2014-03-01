module RecordsHelper
  def sensor_records_json_with_params_path(sensor)
    url = sensor_records_path(sensor, format: :json)
    url + "?#{params.to_query}"
  end
end
