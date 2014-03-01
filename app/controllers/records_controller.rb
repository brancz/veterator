class RecordsController < ApplicationController
  before_action :set_record, only: [:destroy]
  before_action :set_sensor, only: [:show, :new, :index, :create, :destroy, :import, :import_action]

  # GET /sensor/1/records/new
  # GET /sensor/1/records/new.json
  def new
    @record = Record.new
  end

  # GET /sensor/1/records/1
  # GET /sensor/1/records/1.json
  def show
  end

  # GET /sensor/1/records
  # GET /sensor/1/records.json
  def index
    authorize! :read, @sensor
    if !params[:from_date].blank? && !params[:to_date].blank?
      @from = DateTime.strptime(params[:from_date], "%m/%d/%Y").to_date
      @to = DateTime.strptime(params[:to_date], "%m/%d/%Y").to_date
    else
      @from = 24.hours.ago.to_date
      @to = Time.now.to_date
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

  # IMPORT /sensor/1/records/import
  def import
  end

  # IMPORT_ACTION /sensor/1/records/import_action
  def import_action
    Record.import(params[:file], @sensor)
    redirect_to sensor_records_path(@sensor), notice: "Data successfully imported."
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
end
