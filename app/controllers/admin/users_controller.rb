module Admin
  class UsersController < ApplicationController

    def index
      authorize User, policy_class: AdminPolicy
      @users = User.where.not(:id => current_user.id)
    end

    def new
      authorize User, policy_class: AdminPolicy
      @user = User.new
    end

    def create
      authorize User, policy_class: AdminPolicy
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "Created User successfully"
        redirect_to admin_root_path
      else
        render :action => 'new'
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password, :city, :country, :role, :address)
    end

  end
end