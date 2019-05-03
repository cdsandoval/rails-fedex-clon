class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit

  attr_accessor :current_user

  before_action :require_login

  rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized

  protected

  def require_login
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(authentication_token: token)
    end
  end

  def render_unauthorized
    render_error_message('Access denied', 401)
  end

  def render_error_message(message, status)
    errors = { errors: { message: message } }
    render json: errors, status: status
  end

end