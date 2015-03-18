class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_time_zone
  before_action :set_locale

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_url
  end

  def set_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
    Time.zone ||= 'UTC'
  end

  def set_locale
    if user_signed_in?
      user_locale = current_user.user_locale
      I18n.locale = user_locale.to_sym if !user_locale.blank?
    end
    I18n.locale ||= I18n.default_locale
  end
end
