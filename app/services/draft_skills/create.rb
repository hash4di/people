module DraftSkills
  class Create
    attr_reader :draft_skill_attributes

    def initialize(draft_skill_attributes)
      @draft_skill_attributes = draft_skill_attributes
    end

    def call
      create
    end

    private

    def create
      DraftSkill.create(draft_skill_attributes) || false
    end
  end
end
