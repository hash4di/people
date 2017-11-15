class DraftSkillEditPage < SitePrism::Page
  element :reviewer_explanation, '#draft_skill_reviewer_explanation'
  element :accept_button, '.btn-success'
  element :cancel_button, '.btn-warning'
end
