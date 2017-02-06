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
      if draft_skill.accepted?
        update_skill && draft_skill.save
      else
        draft_skill.save
      end
    end

    def update_skill
      draft_skill.skill.update(
        draft_skill.attributes.slice(
          "skill_category_id", "name", "description", "rate_type"
        )
      )
    end
  end
end
