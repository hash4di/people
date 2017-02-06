module Skills
  class CreateFromParams
    attr_reader :skill_params

    def initialize(skill_params)
      @skill_params = skill_params
    end

    def call
      create
    end

    private

    def create
      skill = Skill.new(skill_params)
      skill.ref_name = ref_name
      skill.save
    end

    def ref_name
      "#{skill_category.name}_#{skill_params['name']}".parameterize
    end

    def skill_category
      @skill_category ||= SkillCategory.find(skill_params['skill_category_id'])
    end
  end
end
