module Admin
  class UsersController < ApplicationController

    before_action :authorization_admin

    def index
      @users = User.where.not(:id => current_user.id)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "Created User successfully" 
        redirect_to admin_root_path
      else
        render :action => 'new'
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      params[:user].delete(:password) if params[:user][:password].blank?

      if @user.update(user_params)
        flash[:notice] = "Successfully updated User."
        redirect_to admin_root_path
      else
        render :action => 'edit'
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        flash[:notice] = "Successfully deleted User."
        redirect_to admin_root_path
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password, :city, :country, :role)
    end

    def authorization_admin
      authorize User, :new?, policy_class: AdminPolicy
    end
  end
end