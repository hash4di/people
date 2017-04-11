module Api
  module V3
    class TeamsController < Api::ApiController
      expose(:teams) { Team.all }

      def index
        render json: serialize_teams, root: false
      end

      private

      def serialize_teams
        ActiveModel::ArraySerializer.new(
          teams, each_serializer: Api::V3::TeamSerializer
        )
      end

      def teams_params
        params.permit(:token)
      end
    end
  end
end
