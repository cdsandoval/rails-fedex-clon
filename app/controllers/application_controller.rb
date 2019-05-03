class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authentication, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(current_user)
    if current_user.admin? || current_user.sales?
      return admin_root_path
    elsif current_user.deposit?
      return deposit_root_path
    else
      return root_path
    end
  end

  protected

  def authentication
    unless current_user
      flash[:notice] = "You must login to access to this page or to do this action"
      redirect_to user_session_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :country, :city, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :country, :city, :address])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end