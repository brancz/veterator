RSpec.describe SensorsController do
  describe 'GET index' do
    login_user

    it 'responds with 200' do
      get :index
      expect(response.status).to eq 200
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template 'index'
    end
  end

  describe 'GET show' do
    login_user

    before :each do
      @sensor = create(:sensor, user: @user)
    end

    it 'responds with 200' do
      get :show, { id: @sensor.id }
      expect(response.status).to eq 200
    end

    it 'renders the index template' do
      get :show, { id: @sensor.id }
      expect(response).to render_template 'show'
    end
  end
end

