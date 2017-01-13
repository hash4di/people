module Api::V2
  class UserSkillRatesController < Api::ApiController
    def index
      render json: user_skill_rates, each_serializer: UserSkillRatesSerializer
    end

    private

    def find_user_by_email
      email = params[:user_email][0...-2]
      User.where('email LIKE ?', "#{email}%").first
    end

    def user_skill_rates
      user = find_user_by_email
      user ? user.user_skill_rates : []
    end
  end
end
