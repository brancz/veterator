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

    context 'authorized to access' do
      it 'responds with 200' do
        get :show, { id: @sensor.id }
        expect(response.status).to eq 200
      end

      it 'renders the index template' do
        get :show, { id: @sensor.id }
        expect(response).to render_template 'show'
      end
    end

    context 'unauthorized' do
      it 'responds with 403' do
        sensor = create(:sensor, user: create(:confirmed_user))
        expect {
          get :show, { id: sensor.id }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET edit' do
    login_user

    before :each do
      @sensor = create(:sensor, user: @user)
    end

    context 'authorized to edit' do
      it 'responds with 200' do
        get :edit, { id: @sensor.id }
        expect(response.status).to eq 200
      end

      it 'renders the index template' do
        get :edit, { id: @sensor.id }
        expect(response).to render_template 'edit'
      end
    end

    context 'unauthorized to edit' do
      it 'responds with 403' do
        sensor = create(:sensor, user: create(:confirmed_user))
        expect {
          get :edit, { id: sensor.id }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'PUT/PATCH update' do
    login_user

    before :each do
      @sensor = create(:sensor, user: @user)
    end

    context 'authorized' do
      it 'redirects to sensor show when after valid update' do
        patch :update, id: @sensor.id, sensor: { title: 'new test title' }
        expect(response.status).to eq 302
        expect(response.headers).to include('Location' => "http://test.host/sensors/#{@sensor.id}")
      end
    end
  end

  describe 'POST create' do
    login_user

    context 'authorized' do
      it 'redirects to sensor show when after valid create' do
        post :create, sensor: { title: 'test title', description: 'test desc' }
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE destroy' do
    login_user

    before :each do
      @sensor = create(:sensor, user: @user)
    end

    context 'authorized' do
      it 'redirects to sensor show when after valid update' do
        delete :destroy, { id: @sensor.id }
        expect(response.status).to eq 302
        expect(response.headers).to include('Location' => "http://test.host/sensors")
      end
    end
  end
end

