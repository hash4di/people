module Api::V2
  class UserSkillRatesController < Api::ApiController
    def index
      render json: user_with_skill_rates_hash
    end

    private

    def user_with_skill_rates_hash
      UserSkillRatesFetcher.new(params[:user_id]).call
    end
  end
end
