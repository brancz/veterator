class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :ensure_json_if_token_auth!
  before_filter :token_authenticate_user!
  before_filter :authenticate_user!

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation)}
  end

  def ensure_json_if_token_auth!
    render nothing: true, status: 406 if token_authentication? && params[:format] != 'json'
  end

  def token_authenticate_user!
    if token_authentication?
      user_id = params[:user_id].presence
      user    = user_id && User.find_by_id(user_id)

      if user
        user.authentication_tokens.each do |token|
          if Devise.secure_compare(token.token, params[:token])
            sign_in user, store: false
          end
        end
      end
    end
  end

  def token_authentication?
    params[:token_auth].presence == 1.to_s
  end
end
