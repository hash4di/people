module Users
  class UserSkillRatesController < ApplicationController
    expose(:user) { User.find_by_id(params[:id]) }

    def history; end
  end
end
