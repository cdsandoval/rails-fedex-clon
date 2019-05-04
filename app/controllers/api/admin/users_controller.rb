  class Api::Admin::UsersController < ApiController

    def create
      authorize User, policy_class: AdminPolicy
      user = User.new(user_params)
      if user.save
        render json: user, status: 201
      else
        render_error_message(user.errors.full_messages, 400)
      end
    end

    private

    def user_params
      params.permit(:username, :email, :password,:address, :city, :country, :role)
    end

  end