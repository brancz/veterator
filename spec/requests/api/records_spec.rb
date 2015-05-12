describe '[POST] /api/v1/sensors/:id/records' do
  include Rack::Test::Methods

  before :each do
    @user = User.create(attributes_for(:user).merge(confirmed_at: Time.now))
    @sensor = Sensor.create(attributes_for(:sensor).merge(users: [@user]))
  end

  def authenticate!(user = @user)
    header 'Authorization', user.create_new_authentication_token
  end

  context 'when not authenticated' do
    it 'responds with 401' do
      post "/api/v1/sensors/#{@sensor.id}/records"
      expect(last_response.status).to eq 401
    end
  end

  context 'when sensor resource is not found' do
    it 'responds with 404' do
      authenticate!
      post '/api/v1/sensors/2/records'
      expect(last_response.status).to eq 404
    end
  end

  context 'when not authorized to access sensor' do
    it 'responds with 403' do
      other_user = create :confirmed_user
      authenticate! other_user
      post "/api/v1/sensors/#{@sensor.id}/records"
      expect(last_response.status).to eq 403
    end
  end

  context 'when resource is valid' do
    it 'responds with 201' do
      authenticate!
      post "/api/v1/sensors/#{@sensor.id}/records", { value: 10 }, {
        'Content-Type' => 'application/json'
      }
      expect(last_response.status).to eq 201
    end

    it 'creates the resource' do
      authenticate!
      expect{
        post "/api/v1/sensors/#{@sensor.id}/records", { value: 10 }, {
          'Content-Type' => 'application/json'
        }
      }.to change { Record.original.count }.by 1
    end

    it 'queues an aggregation job' do
      authenticate!
      expect do
        post "/api/v1/sensors/#{@sensor.id}/records", { value: 10 }, {
          'Content-Type' => 'application/json'
        }
      end.to enqueue_a(AggregateRecordsJob)
    end

    it 'shows the resource' do
      authenticate!
      post "/api/v1/sensors/#{@sensor.id}/records", { value: 10 }, {
        'Content-Type' => 'application/json'
      }
      expect(last_response.body).to eq ({
        value: '10.0', sensor_id: @sensor.id
      }.to_json)
    end
  end

  context 'when resource is invalid' do
    it 'responds with 422' do
      authenticate!
      post "/api/v1/sensors/#{@sensor.id}/records", '{}', {
        'Content-Type' => 'application/json'
      }
      expect(last_response.status).to eq 422
    end

    it 'shows the errors' do
      authenticate!
      post "/api/v1/sensors/#{@sensor.id}/records", '{}', {
        'Content-Type' => 'application/json'
      }
      expect(last_response.body).to eq({
        message: ["Value can't be blank"]
      }.to_json)
    end
  end
end

