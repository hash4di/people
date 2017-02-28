module DraftSkills
  class Create
    attr_reader :params, :type, :user, :skill, :draft_skill

    def initialize(params:, type:, user:, skill: nil)
      @params = params
      @type = type
      @user = user
      @skill = skill
      initialize_draft_skill!
      dump_original_skill_details if @draft_skill.update_type?
    end

    def save!
      draft_skill.save
    end

    def valid?
      draft_skill.valid?
    end

    def errors
      valid?
      draft_skill.errors
    end

    private

    def dump_original_skill_details
      @draft_skill.original_skill_details = original_skill_details
    end

    def original_skill_details
      @original_skill_details ||= skill.attributes.slice('name', 'description', 'rate_type', 'skill_category_id')
    end

    def initialize_draft_skill!
      @draft_skill ||= begin
        draft_skill_attributes['skill_id'] = skill.id if skill
        DraftSkill.new(draft_skill_attributes)
      end
    end

    def draft_skill_attributes
      @draft_skill_attributes ||= params.merge(
        'requester_id' => user.id,
        'draft_type' => type,
        'draft_status' => 'created'
      )
    end
  end
end
