module Api::V2
  class UserSkillRatesController < Api::ApiController
    expose(:user_skill_rates) do
      ::Api::V2::UserSkillRatesQuery.new(scope_params).call
    end

    def index
      render json: user_skill_rates, each_serializer: UserSkillRatesSerializer
    end

    private

    def scope_params
      params.permit(:user_email, :scope, :token)
    end
  end
end
