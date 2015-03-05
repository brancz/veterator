RSpec.describe RecordsController do
  describe 'GET index' do
    login_user

    before :each do
      user = create(:confirmed_user)
      @sensor = create(:sensor, user: user)
    end

    it 'responds with 200' do
      get :index, { sensor_id: @sensor }
      expect(response.status).to eq 200
    end

    it 'renders the index template' do
      get :index, { sensor_id: @sensor }
      expect(response).to render_template 'index'
    end
  end
end

