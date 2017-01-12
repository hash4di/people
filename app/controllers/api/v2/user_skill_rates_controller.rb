module Api::V2
  class UserSkillRatesController < Api::ApiController
    def index
      user = find_user_by_email
      render json: user, serializer: UserSkillRatesSerializer
    end

    private

    def find_user_by_email
      email = params[:user_email][0...-2]
      pl = email + 'pl'
      co = email + 'co'
      User.find_by(email: pl) || User.find_by(email: co)
    end
  end
end
