module Api::V2
  class UserSkillRatesController < Api::ApiController
    def index
      user = User.find_by(email: params[:user_email])
      render json: user, serializer: UserSkillRatesSerializer
    end
  end
end
