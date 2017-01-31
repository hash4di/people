module Users
  class UserSkillRatesController < ApplicationController
    expose_decorated(:user) { User.find_by(id: params[:id]) }
    expose(:skill_categories) { SkillCategory.all }

    def history
      authorize user
    end
  end
end
