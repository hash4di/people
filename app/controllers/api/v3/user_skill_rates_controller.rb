module Api
  module V3
    class UserSkillRatesController < Api::ApiController
      before_action :set_user, only: :index

      expose(:user_skill_rates) do
        UserSkillRatesQuery.new(@user).results_for_category(
          filter_params[:category]
        )
      end

      def index
        render json: serialize_user_skill_rates, root: false
      end

      private

      def serialize_user_skill_rates
        ActiveModel::ArraySerializer.new(
          user_skill_rates.includes(skill: :skill_category),
          each_serializer: ContentsHistorySerializer,
          context: serializer_context
        )
      end

      def serializer_context
        {
          start_date: filter_params[:start_date]&.to_datetime,
          end_date: filter_params[:end_date]&.to_datetime
        }
      end

      def filter_params
        params.permit(:category, :start_date, :end_date, :user_id)
      end

      def set_user
        @user ||= User.find_by_id(filter_params[:user_id])
        if @user.blank?
          render json: "Sorry, such user doesn't exist.", status: 404 and return
        end
      end
    end
  end
end
