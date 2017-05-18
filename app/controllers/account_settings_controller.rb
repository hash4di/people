class AccountSettingsController < ApplicationController
  expose(:user) { current_user }

  def index
  end

  def generate
    new_api_token = SecureRandom.uuid
    if user.update(api_token: new_api_token)
      flash[:notice] = 'Your API token has been generated.'
    else
      flash[:alert] = 'Sorry, something went wrong.'
    end
    redirect_to action: 'index'
  end
end
