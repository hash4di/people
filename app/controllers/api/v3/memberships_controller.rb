module Api
  module V3
    class MembershipsController < Api::ApiController
      expose(:memberships) do
        Api::V3::MembershipsQuery.new.all_overlapped(filter_params)
      end

      def index
        render json: serialize_memberships, root: false
      end

      private

      def serialize_memberships
        ActiveModel::ArraySerializer.new(
          memberships, each_serializer: Api::V3::MembershipsHistorySerializer
        )
      end

      def filter_params
        params.permit(:user_email, :f2f_date, :token)
      end
    end
  end
end
