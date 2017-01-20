require_relative '../../../db/seeds/data/skills_and_categories'

module Skills
  class GenerateFromSeeds

    def initialize
      generate
    end

    def self.call
      new
      "#{Skill.count} skills was modificated."
    end

    private

    def generate
      skill_seeds.each do |skill_representation|
        find_or_create_skill(
          skill_representation[:ref_name],
          skill_representation
        )
      end
    end

    def skill_seeds
      return SKILLS_AND_CATEGORIES if SKILLS_AND_CATEGORIES.present?
      fail
    rescue
      raise 'Please run `rake skills:generate_seeds` first'
    end

    def find_or_create_skill_category(name)
      ::SkillCategory.find_or_create_by(name: name)
    end

    def find_or_create_skill(ref_name, skill_representation)
      skill_category = find_or_create_skill_category(skill_representation[:category])
      ::Skill.find_or_create_by(ref_name: ref_name) do |skill|
        skill.skill_category = skill_category
        skill.rate_type = rate_type(skill_representation[:rating])
        skill.name = skill_representation[:name]
        skill.description = skill_representation[:description]
      end
    end

    def rate_type(name)
      {
        'int' => 'range',
        'boolean' => 'boolean',
      }.fetch(name)
    end
  end
end
