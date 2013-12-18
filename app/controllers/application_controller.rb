class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :update_sanitized_params, if: :devise_controller?
	before_filter :ensure_json_if_token_auth!
	before_filter :token_authenticate_user!
	before_filter :authenticate_user!
	before_filter :set_layout!

	rescue_from CanCan::AccessDenied do |exception|
		render_not_authorized
	end

	def render_not_authorized
		respond_to do |format|
			format.html { render file: "#{Rails.root}/public/403.html", status: 403, layout: false }
			format.json { render json: { error: true, message: "Error 403, you don't have permissions for this operation." } }
		end
	end

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
						token.renew
					end
				end
			end
		end
	end

	def token_authentication?
		params[:token_auth].presence == 1.to_s
	end

	def set_layout!
		if controller_name == 'registrations' && (action_name == 'edit' || action_name == 'update')
			self.class.layout 'application'
		elsif controller_name == 'registrations'
			self.class.layout 'devise'
		end
	end
end
