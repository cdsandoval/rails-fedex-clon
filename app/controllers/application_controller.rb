class ApplicationController < ActionController::Base
  include Pundit
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protect_from_forgery with: :exception

  before_action :authentication, unless: :api_or_devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller? 
  before_action :require_login, if: :api_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected

  def authentication
    unless current_user
      flash[:notice] = "You must login to access to this page or to do this action"
      redirect_to root_path
    end
  end

  def api_controller?
    params[:controller].include?("api")
  end

  def api_or_devise_controller?
    api_controller? || devise_controller?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :country, :city, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :country, :city, :address])
  end

  
  def require_login
    authenticate_token || render_unauthorized('Access denied')
  end

  def render_unauthorized(message)
    errors = { errors: { message: message } }
    render json: errors, status: :unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      current_user = User.find_by(authentication_token: token)
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end