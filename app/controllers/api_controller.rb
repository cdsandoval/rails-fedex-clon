class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_accessor :current_user

  before_action :require_login

  def require_login
    authenticate_token || render_unauthorized('Access denied')
  end

  def render_unauthorized(message)
    errors = { errors: { message: message } }
    render json: errors, status: :unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(authentication_token: token)
    end
  end
end