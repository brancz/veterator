class RecordsController < ApplicationController
  layout 'sensor'
  before_action :set_sensor

  # GET /sensors/:sensor_id/records
  # GET /sensors/:sensor_id/records.json
  def index
    authorize! :show, @sensor
    @records = @sensor.records

    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@sensor.title}.csv\""
        render 'records/index.csv.erb'
      end
      format.json { render json: @records }
    end
  end

  private

  def set_sensor
    @sensor = Sensor.find(params[:sensor_id])
  end
end

