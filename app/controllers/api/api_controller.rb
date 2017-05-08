module Api
  class ApiController < ActionController::Base
    include ContextFreeRepos

    before_filter :authenticate_api!
    respond_to :json

    decent_configuration do
      strategy DecentExposure::StrongParametersStrategy
    end

    private

    def authenticate_api!
      if current_user.blank? && params[:token] != AppConfig.api_token
        unauthorized!
      end
    end

    def authenticate_admin!
      unauthorized! unless current_user.try(:admin?)
    end

    def authorized!
      render(nothing: true, status: 200)
    end

    def unauthorized!
      render(nothing: true, status: 403)
    end
  end
end
