class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :time_zone, :user_locale)
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_url
  end
end

