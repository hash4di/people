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
      unless draft_skill.valid?
        revert_status_to_created
        return false
      end
      update_or_create_skill if draft_skill.accepted?
      draft_skill.save
    end

    def revert_status_to_created
      draft_skill.draft_status = 'created'
    end

    def update_or_create_skill
      draft_skill.create_type? ? create_skill : update_skill
    end

    def create_skill
      skill = Skill.create(skill_params)
      draft_skill.skill = skill
      CreateRatesForSkillJob.perform_async(skill_id: skill.id)
      Notifications::SkillCreatedJob.perform_async(skill_id: skill.id)
    end

    def update_skill
      draft_skill.skill.update(skill_params)
      Notifications::SkillUpdatedJob.perform_async(
        skill_id: draft_skill.skill.id
      )
    end

    def skill_params
      @skill_params ||= draft_skill.attributes.slice(
        'skill_category_id', 'name', 'description', 'rate_type'
      )
    end
  end
end
