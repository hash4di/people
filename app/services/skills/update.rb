module Skills
  class Update
    attr_reader :skill, :skill_params, :user

    def initialize(skill, skill_params, user)
      @skill = skill
      @skill_params = skill_params
      @user = user
    end

    def call
      update
    end

    private

    def update
      skill.assign_attributes(skill_params)
      skill.valid? && DraftSkills::Create.new(draft_skill_attributes).call
    end

    def draft_skill_attributes
      @draft_skill_attributes ||= skill.attributes.slice(
        'description', 'name', 'rate_type', 'skill_category_id'
      ).merge(
        'requester_id' => user.id,
        'skill_id' => @skill.id,
        'draft_type' => 'update',
        'draft_status' => 'created',
        'requester_explanation' => @skill.requester_explanation
      )
    end
  end
end
