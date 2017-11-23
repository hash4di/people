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
      if draft_skill.accepted?
        draft_skill.marked_for_delete? ? destroy_skill : update_or_create_skill
      end
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
      sf_skills_repository.sync(skill)
      CreateRatesForSkillJob.perform_async(skill_id: skill.id)
      Notifications::SkillCreatedJob.perform_async(
        draft_skill_id: draft_skill.id
      )
    end

    def update_skill
      skill = draft_skill.skill
      skill.update(skill_params)
      sf_skills_repository.sync(skill)
      Notifications::SkillUpdatedJob.perform_async(
        draft_skill_id: draft_skill.id
      )
    end

    def destroy_skill
      skill = draft_skill.skill
      draft_skill.update(skill_id: nil) && skill.destroy
    end

    def skill_params
      @skill_params ||= draft_skill.attributes.slice(
        'skill_category_id', 'name', 'description', 'rate_type'
      )
    end

    def sf_skills_repository
      @salesforce_skills_repository ||= Salesforce::SkillsRepository.new(Restforce.new)
    end
  end
end
