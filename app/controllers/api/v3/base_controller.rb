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
        email = params[:email]
        api_token = params[:api_token]
        return false if email.blank? || api_token.blank?
        User.where(email: email, api_token: api_token).active.exists?
      end
    end
  end
end
