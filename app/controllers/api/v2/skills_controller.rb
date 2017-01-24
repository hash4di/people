module Api::V2
  class SkillsController < Api::ApiController
    def index
      render json: grouped_skills_by_category
    end

    private

    def grouped_skills_by_category
      skills = Skill.eager_load(:skill_category).all
      skills.group_by do |skill|
        skill.skill_category.name
      end
    end
  end
end
