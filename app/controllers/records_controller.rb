class RecordsController < ApplicationController
  include DateFilter
  layout 'sensor'
  before_action :set_sensor

  # GET /sensors/:sensor_id/records
  # GET /sensors/:sensor_id/records.json
  def index
    authorize! :show, @sensor
    set_filter_dates
    @records = @sensor.records.where(created_at: @from..@to)

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

