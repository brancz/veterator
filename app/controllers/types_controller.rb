class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # GET /types
  # GET /types.json
  def index
    authorize! :read, Type
    @types = Type.all
  end

  # GET /types/1
  # GET /types/1.json
  def show
    authorize! :read, Type
  end

  # GET /types/new
  def new
    authorize! :create, Type
    @type = Type.new
  end

  # GET /types/1/edit
  def edit
    authorize! :update, Type
  end

  # POST /types
  # POST /types.json
  def create
    authorize! :create, Type
    @type = Type.new(type_params)

    respond_to do |format|
      if @type.save
        format.html { redirect_to types_path, notice: 'Type was successfully created.' }
        format.json { render action: 'index', status: :created, location: @type }
      else
        format.html { render action: 'new' }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /types/1
  # PATCH/PUT /types/1.json
  def update
    authorize! :update, Type
    respond_to do |format|
      if @type.update(type_params)
        format.html { redirect_to types_path, notice: 'Type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    authorize! :destroy, Type
    @type.destroy
    respond_to do |format|
      format.html { redirect_to types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:type).permit(:name)
    end
end
