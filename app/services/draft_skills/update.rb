module DraftSkills
  class Update
    attr_reader :draft_skill, :draft_skill_params

    def initialize(draft_skill, draft_skill_params)
      @draft_skill = draft_skill
      @draft_skill_params = draft_skill_params
    end

    def call
      update
    end

    private

    def update
      draft_skill.assign_attributes(draft_skill_params)
      return false unless draft_skill.valid?
      update_or_create_skill if draft_skill.accepted?
      draft_skill.save
    end

    def update_or_create_skill
      draft_skill.create_type? ? create_skill : update_skill
    end

    def create_skill
      skill = ::Skills::CreateFromParams.new(skill_params).call
      draft_skill.skill = skill
    end

    def update_skill
      draft_skill.skill.update(skill_params)
    end

    def skill_params
      @skill_params ||= draft_skill.attributes.slice(
        'skill_category_id', 'name', 'description', 'rate_type'
      )
    end
  end
end
