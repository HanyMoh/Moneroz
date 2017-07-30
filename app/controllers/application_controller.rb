class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name, :email, :password, :password_confirmation, :current_password])
  end

protected

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert =>'ليس لك صلاحية لذلك  الإجراء'# exception.message,
  end
end
