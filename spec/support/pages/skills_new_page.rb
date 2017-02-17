class SkillsNewPage < SitePrism::Page
  set_url '/skills/new'

  element :skill_name, '#skill_name'
  element :skill_description, '#skill_description'
  element :skill_rate_type, '#skill_rate_type'
  element :skill_category, '#skill_skill_category_id'
  element :requester_explanation, '#skill_requester_explanation'
  element :create_skill, '.btn-success'
end
