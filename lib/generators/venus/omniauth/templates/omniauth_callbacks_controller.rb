class Users::OmniauthCallbacksController < ApplicationController

  def callback
    provider = params[:provider]
    if not current_user.blank?
      current_user.bind_service(env["omniauth.auth"])
      sign_in_and_redirect(current_user, :notice => "Successfully binded to #{provider}.")
    else
      @user = User.find_or_create_by_omniauth(env["omniauth.auth"])
      flash[:notice] = "Sign in with #{provider.to_s.titleize} successfully."
      sign_in_and_redirect @user, :event => :authentication, :notice => "Login successfully."
    end
  end

end
