module Api
  module V3
    class BaseController < Api::ApiController
      private

      def authenticate_api!
        if current_user.blank? && params[:token] != AppConfig.api_token && !user_authenticated?
          unauthorized!
        end
      end

      def user_authenticated?
        email = request.headers["X-Email"]
        api_token = request.headers["X-Api-Token"]
        return false if email.blank? || api_token.blank?
        User.where(email: email, api_token: api_token).active.exists?
      end
    end
  end
end
