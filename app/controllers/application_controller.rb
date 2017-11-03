class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # def after_sign_in_path_for(resource)
  #     request.env['omniauth.origin'] || root_path
  # end
  protected
  # def configure_permitted_parameters
  #  devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :email, :password, :password_confirmation, :job_type, :profile_photo])
  #  devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
  # #  devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
  # end

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :profile_photo, :job_type, :username, :email])
   devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password,:password_confirmation])
   devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :profile_photo])
  end
end
