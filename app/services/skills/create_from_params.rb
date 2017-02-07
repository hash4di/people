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
      skill.set_ref_name!
      skill.save
      skill
    end
  end
end
