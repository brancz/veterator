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
      @sensor = create(:sensor, users: [@user])
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
      it 'responds with access denied' do
        sensor = create(:sensor, users: [create(:confirmed_user)])
        expect {
          get :show, { id: sensor.id }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET edit' do
    login_user

    before :each do
      @sensor = create(:sensor, users: [@user])
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
      it 'responds with access denied' do
        sensor = create(:sensor, users: [create(:confirmed_user)])
        expect {
          get :edit, { id: sensor.id }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'PUT/PATCH update' do
    login_user

    before :each do
      @sensor = create(:sensor, users: [@user])
    end

    context 'authorized' do
      it 'redirects to sensor show when after valid update' do
        patch :update, id: @sensor.id, sensor: { title: 'new test title' }
        expect(response.status).to eq 302
        expect(response.headers).to include('Location' => "http://test.host/sensors/#{@sensor.id}")
      end

      it 'should update the resource' do
        updated_attributes = { title: 'new test title', description: 'new description', chart_type: 'monotone' }
        patch :update, id: @sensor.id, sensor: updated_attributes
        expect(response.status).to eq 302
        expect(response.headers).to include('Location' => "http://test.host/sensors/#{@sensor.id}")
        @sensor = Sensor.find(@sensor.id)
        expect(@sensor.title).to eq(updated_attributes[:title])
        expect(@sensor.description).to eq(updated_attributes[:description])
        expect(@sensor.chart_type).to eq(updated_attributes[:chart_type])
      end
    end

    context 'unauthorized to update' do
      it 'responds with access denied' do
        sensor = create(:sensor, users: [create(:confirmed_user)])
        expect {
          patch :update, id: sensor.id, sensor: { title: 'new test title' }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'POST create' do
    login_user

    context 'authorized' do
      it 'redirects to sensor show when after valid create' do
        sensor_attributes = {
          title: 'test title',
          description: 'test desc',
          chart_type: 'monotone'
        }
        post :create, sensor: sensor_attributes
        expect(response.status).to eq 302
      end

      it 'adds new sensor entry' do
        expect{
          sensor_attributes = {
            title: 'test title',
            description: 'test desc',
            chart_type: 'monotone'
          }
          post :create, sensor: sensor_attributes
        }.to change{ Sensor.count }.by(1)
      end
    end
  end

  describe 'DELETE destroy' do
    login_user

    before :each do
      @sensor = create(:sensor, users: [@user])
    end

    context 'authorized' do
      it 'redirects to sensor show when after valid update' do
        delete :destroy, { id: @sensor.id }
        expect(response.status).to eq 302
        expect(response.headers).to include('Location' => "http://test.host/sensors")
      end

      it 'should delete the sensor' do
        delete :destroy, { id: @sensor.id }
        expect(Sensor.exists?(@sensor.id)).to be false
      end
    end

    context 'unauthorized to delete' do 
      it 'responds with access denied' do
        sensor = create(:sensor, users: [create(:confirmed_user)])
        expect{
          delete :destroy, { id: sensor.id }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end

