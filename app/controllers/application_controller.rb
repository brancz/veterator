class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :update_sanitized_params, if: :devise_controller?
	before_filter :ensure_json_if_token_auth!
	before_filter :token_authenticate_user!
	before_filter :authenticate_user!
	before_filter :set_layout!

	rescue_from ActiveRecord::RecordNotFound do |exception|
    puts 'RecordNotFound'
		render_not_found
	end

	rescue_from ActionController::RoutingError do |exception|
    puts 'RoutingError'
		render_not_found
	end

	rescue_from CanCan::AccessDenied do |exception|
		render_not_authorized
	end
	
	def render_not_found
		respond_to do |format|
			format.html { render file: "#{Rails.root}/public/404.html", status: 404, layout: false }
			format.json { render json: { error: true, message: "Error 404, the resource you requested does not exist or has been moved." } }
		end
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
		if (controller_name == 'registrations' && (action_name == 'edit' || action_name == 'update')) ||
       (controller_name == 'users' && (action_name == 'confirm_delete' || action_name == 'delete_user' || action_name == 'change_password' || action_name == 'update_password'))
			self.class.layout 'devise_logged_in'
		elsif controller_name == 'registrations'
			self.class.layout 'devise'
		end
	end

	def self.adapter
		ActiveRecord::Base.configurations[Rails.env]['adapter']
	end
end
