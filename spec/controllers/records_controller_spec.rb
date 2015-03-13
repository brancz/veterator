RSpec.describe RecordsController do
  describe 'GET index' do
    login_user

    before :each do
      @sensor = create(:sensor, user: @user)
    end

    context 'authorized to view sensor' do
      it 'responds with 200' do
        get :index, { sensor_id: @sensor }
        expect(response.status).to eq 200
      end

      it 'renders the index template' do
        get :index, { sensor_id: @sensor }
        expect(response).to render_template 'index'
      end
    end

    context 'unauthorized to view sensor' do
      it 'responds with access denied' do
        sensor = create(:sensor, user: create(:confirmed_user))
        expect {
          get :index, { sensor_id: sensor }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end

