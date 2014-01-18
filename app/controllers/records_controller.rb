class RecordsController < ApplicationController
  before_action :set_record, only: [:destroy]
	before_action :set_sensor, only: [:index, :create, :destroy]

  # GET /sensor/1/records
  # GET /sensor/1/records.json
  def index
		authorize! :read, @sensor
		if !params[:from].blank? && !params[:to].blank?
			@from = time_from_params from_params
			@to = time_from_params to_params
		else
			@from = 24.hours.ago
			@to = Time.now
		end
		@records = Record.where(sensor: @sensor, created_at: @from..@to)
    respond_to do |format|
      format.html
      format.json
      format.csv { send_data @records.to_csv }
      format.xls
    end
  end

  # POST /sensor/1/records
  # POST /sensor/1/records.json
  def create
    @record = Record.new(record_params)
    @record.sensor = @sensor

    respond_to do |format|
      if @record.save
        format.html { redirect_to sensor_record_path(@sensor, @record), notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new' }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensor/1/records/1
  # DELETE /sensor/1/records/1.json
  def destroy
		!authorize :destroy, @record
    @record.destroy
    respond_to do |format|
      format.html { redirect_to sensor_records_path(@sensor) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

		def set_sensor
      @sensor = Sensor.find(params[:sensor_id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:value)
    end

		def from_params
			params.require(:from).permit(:year, :month, :day)
		end

		def to_params
			params.require(:to).permit(:year, :month, :day)
		end

		def time_from_params(params)
			Time.new(params[:year], params[:month], params[:day], 0)
		end
end
