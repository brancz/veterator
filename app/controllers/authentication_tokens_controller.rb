class AuthenticationTokensController < ApplicationController
  layout 'devise_logged_in'
  before_action :set_authentication_token, only: [:update, :destroy]

  # GET /authentication_tokens
  def index
    @authentication_tokens = current_user.authentication_tokens
  end

  # POST /authentication_tokens
  def create
    @authentication_token = AuthenticationToken.new
    @authentication_token.token = SecureRandom.hex
    @authentication_token.valid_until = 2.days.from_now
    @authentication_token.user = current_user

    respond_to do |format|
      if @authentication_token.save
        format.html { redirect_to authentication_tokens_path, notice: 'Authentication token was successfully created.' }
      else
        format.html { render action: 'index' }
      end
    end
  end

  # PATCH/PUT /authentication_tokens/1
  def update
		authorize! :update, @authentication_token
    respond_to do |format|
      if @authentication_token.renew
        format.html { redirect_to authentication_tokens_path, notice: 'Token was successfully renewed.' }
      else
        format.html { render action: 'index' }
      end
    end
  end

  # DELETE /authentication_tokens/1
  def destroy
		authorize! :destroy, @authentication_token
    @authentication_token.destroy
    respond_to do |format|
      format.html { redirect_to authentication_tokens_url, notice: 'Token successfully removed.' }
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
