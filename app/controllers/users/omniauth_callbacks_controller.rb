class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    callback_provider("Facebook")
  end

  def github
    callback_provider("GitHub")
  end

  def failure
    redirect_to root_path
  end

  private

  def callback_provider(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @provider = Provider.from_omniauth(request.env['omniauth.auth'], @user)


    if @provider.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: provider)
    else
      key_name = "devise.#{provider.downcase}_data"
      session[key_name] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end





end