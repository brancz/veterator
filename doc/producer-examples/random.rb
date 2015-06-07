require 'net/http'
require 'json'

token = ENV['VETERATOR_API_TOKEN']
sensor_id = 1
uri = URI("http://192.168.59.103:5000/api/v1/sensors/#{sensor_id}/records")

loop do
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri.path, initheader = {
      'Content-Type' => 'application/json',
      'Authorization' => token
  })
  req.body = { value: Random.rand }.to_json
  res = http.request(req)
  sleep(10)
end
