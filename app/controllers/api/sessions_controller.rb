class Api::SessionsController < ApiController
  skip_before_action :require_login, only: :create

  def create
    if params[:email] && params[:password]
      user = User.valid_login?(params[:email], params[:password])
      if user
        render json: { token: user.authentication_token }
      else
        render_unauthorized('Incorrect email or password')
      end
    else
      errors = { errors: { message: "You have to pass the parameters 'email' and 'password'" } }
      render json: errors, status: :bad_request
    end
  end

  def destroy
    current_user.invalidate_token
    head :ok
  end
end