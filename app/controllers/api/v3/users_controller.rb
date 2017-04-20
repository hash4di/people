module Api
  module V3
    class UsersController < Api::V3::BaseController
      expose(:technical_users) { ScheduledUsersRepository.new.all }
      skip_before_filter :authenticate_api!, only: [:sign_in]

      def technical
        render json: technical_users, each_serializer: Api::V3::UserWithMembershipsSerializer, root: false
      end

      def sign_in
        user_exist = User.where(
          email: user_params[:email],
          api_token: user_params[:api_token]
        ).active.exists?
        user_exist ? authorized! : unauthorized!
      end

      private

      def user_params
        params.permit(:email, :api_token)
      end
    end
  end
end
