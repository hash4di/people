class DraftSkillsPage < SitePrism::Page
  set_url '/draft_skills{/skill_id}'

  elements :edit_skill, '.btn.btn-primary'
end
