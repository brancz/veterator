class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
	before_action :set_sensor, only: [:index, :edit, :new, :create, :update, :destroy]
  before_filter :authenticate_user!

  # GET /records
  # GET /records.json
  def index
		if !params[:from].blank? && !params[:to].blank?
			@from = time_from_params from_params
			@to = time_from_params to_params
			@records = Record.where(sensor: @sensor, created_at: @from..@to)
		else
			@records = Record.where(sensor: @sensor)
		end
		@from ||= Time.now
		@to ||= Time.now
		puts @from
		puts @to
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
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

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to sensor_record_path(@sensor, @record), notice: 'Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
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
			params.require(:from).permit(:year, :month, :day, :hour, :minute)
		end

		def to_params
			params.require(:to).permit(:year, :month, :day, :hour, :minute)
		end

		def time_from_params(params)
			Time.new(params[:year], params[:month], params[:day], params[:hour], params[:minute], 0)
		end
end
