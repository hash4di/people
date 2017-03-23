class DraftSkill::SkillDetails
  include Virtus.model

  attribute :name, String
  attribute :description, String
  attribute :rate_type, String
  attribute :skill_category_id, Integer

  def self.dump(original_skill_details)
    original_skill_details.to_hash
  end

  def self.load(original_skill_details)
    new(original_skill_details)
  end

  def skill_category
    SkillCategory.find(skill_category_id)
  end
end
