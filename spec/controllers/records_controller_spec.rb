RSpec.describe RecordsController do
  describe 'GET export' do
    render_views
    login_user

    context 'authorized to access sensor' do
      it 'renders all records as csv' do
        sensor = create(:sensor, users: [@user])
        record = create(:record, sensor: sensor)

        get :export, sensor_id: sensor.id, format: :csv
        expect(response.headers).to include({'Content-Disposition' => 'attachment; filename="Test Title.csv"'})
        expect(response.body).to eq "created_at,value\n#{record.created_at},#{record.value}\n"
      end
    end
  end

  describe 'GET index' do
    login_user

    before :each do
      @sensor = create(:sensor, users: [@user])
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
        sensor = create(:sensor, users: [create(:confirmed_user)])
        expect {
          get :index, { sensor_id: sensor }
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end

