class AuthenticationTokensController < ApplicationController
  before_action :set_authentication_token, only: [:show, :edit, :update, :destroy]

  # GET /authentication_tokens
  # GET /authentication_tokens.json
  def index
    @authentication_tokens = AuthenticationToken.all
  end

  # GET /authentication_tokens/1
  # GET /authentication_tokens/1.json
  def show
  end

  # GET /authentication_tokens/new
  def new
    @authentication_token = AuthenticationToken.new
  end

  # GET /authentication_tokens/1/edit
  def edit
  end

  # POST /authentication_tokens
  # POST /authentication_tokens.json
  def create
    @authentication_token = AuthenticationToken.new(authentication_token_params)

    respond_to do |format|
      if @authentication_token.save
        format.html { redirect_to @authentication_token, notice: 'Authentication token was successfully created.' }
        format.json { render action: 'show', status: :created, location: @authentication_token }
      else
        format.html { render action: 'new' }
        format.json { render json: @authentication_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authentication_tokens/1
  # PATCH/PUT /authentication_tokens/1.json
  def update
    respond_to do |format|
      if @authentication_token.update(authentication_token_params)
        format.html { redirect_to @authentication_token, notice: 'Authentication token was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @authentication_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentication_tokens/1
  # DELETE /authentication_tokens/1.json
  def destroy
    @authentication_token.destroy
    respond_to do |format|
      format.html { redirect_to authentication_tokens_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authentication_token
      @authentication_token = AuthenticationToken.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authentication_token_params
      params.require(:authentication_token).permit(:token, :valid_until, :user_id)
    end
end
