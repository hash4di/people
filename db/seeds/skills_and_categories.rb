require './db/seeds/data/skills_and_categories'

SKILLS_AND_CATEGORIES.each do |skill_representation|
  skill_category = ::SkillCategory.find_or_create_by(name: skill_representation[:category])

  translated_rate_type = {
    'int' => 'range',
    'boolean' => 'boolean',
  }.fetch(skill_representation[:rating])

  ::Skill.find_or_create_by(ref_name: skill_representation[:ref_name]) do |skill|
    skill.skill_category = skill_category
    skill.rate_type = translated_rate_type
    skill.name = skill_representation[:name]
    skill.description = skill_representation[:description]
  end
end
