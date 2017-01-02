module Api::V2
  class UserSkillRatesController < Api::ApiController
    def index
      user = User.find(params[:user_id])
      render json: user, serializer: UserSkillRatesSerializer
    end
  end
end
