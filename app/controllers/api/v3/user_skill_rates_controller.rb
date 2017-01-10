module Api
  module V3
    class UserSkillRatesController < Api::ApiController
      expose(:user_skill_rates) do
        UserSkillRatesQuery.new(current_user).results_for_category(
          filter_params[:category]
        )
      end

      # TODO: remove N+1 query fot skill and skill_categories
      def index
        render json: serialize_user_skill_rates, root: false
      end

      private

      def serialize_user_skill_rates
        ActiveModel::ArraySerializer.new(
          user_skill_rates, each_serializer: ContentsHistorySerializer, context: {
           start_date: filter_params[:start_date]&.to_datetime,
           end_date: filter_params[:end_date]&.to_datetime
         }
        ).to_json
      end

      def filter_params
        params.permit(:category, :start_date, :end_date)
      end
    end
  end
end
