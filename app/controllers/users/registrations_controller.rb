class Users::RegistrationsController < Devise::RegistrationsController
	protected

	def after_inactive_sign_up_path_for(resource)
		'/users/sign_in'
	end

	def sign_up_params
		result = super
		result[:roles] = [Role.find_by_name("user")]
		result
	end
end

