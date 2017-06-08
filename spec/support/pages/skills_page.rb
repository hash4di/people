class SkillsPage < SitePrism::Page
  set_url '/skills'

  element :add_new_skill, '.pull-right', text: 'Add new skill'
  elements :edit_skill, '.skills__actions .btn.btn-primary'
end
