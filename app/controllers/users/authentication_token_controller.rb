class Users::AuthenticationTokenController < ApplicationController
  layout 'devise'

  # GET /autentication_token
  def index
  end

  # POST /authentication_token
  def create
    @token = current_user.create_new_authentication_token
    render :index
  end
end
