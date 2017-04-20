module Api
  module V3
    class TeamMembersController < Api::V3::BaseController
      expose(:team_members) { team.users.active }
      expose(:team) do
        Team.where(name: team_members_params['team_name']).first
      end

      def index
        render json: serialize_team_members, root: false
      end

      private

      def serialize_team_members
        ActiveModel::ArraySerializer.new(
          team_members, each_serializer: Api::V3::TeamMemberSerializer
        )
      end

      def team_members_params
        params.permit(:token, :team_name)
      end
    end
  end
end
