require 'spec_helper'

describe 'Skills page', js: true do
  let(:skills_page) { App.new.skills_page }
  let(:skills_new_page) { App.new.skills_new_page }
  let(:draft_skills_page) { App.new.draft_skills_page }
  let(:skill_edit_page) { App.new.skill_edit_page }


  let(:skill_category_1) { create :skill_category, name: 'backend' }
  let(:skill_category_2) { create :skill_category, name: 'ios' }

  let(:skills_range) { create_list :skill, 2, :with_range_rate_type, skill_category: skill_category_1 }
  let(:skills_boolean) { create_list :skill, 2, :with_boolean_rate_type, skill_category: skill_category_2 }

  let!(:admin_user) { create(:user, :admin, skills: skills_range + skills_boolean) }

  before do
    log_in_as admin_user
    skills_page.load
  end

  def skill_form(page)
    page.skill_name.set 'capybara'
    page.skill_description.set 'test test test'
    page.skill_rate_type.select 'range'
    page.skill_category.select 'backend'
    page.requester_explanation.set 'test test test'
    page.create_skill.click
  end

  it 'adds new skill' do
    skills_page.add_new_skill.click
    skill_form(skills_new_page)
    expect(draft_skills_page).to have_content I18n.t('skills.message.create.success')
  end

  it 'tries to add new skill without mandatory fields' do
    skills_page.add_new_skill.click
    skills_new_page.create_skill.click
    expect(skills_page).to have_content 'Skill category and skill name have to be set.'
  end

  it 'edits skill' do
    skills_page.edit_skill.first.click
    skill_form(skill_edit_page)
    expect(draft_skills_page).to have_content I18n.t('skills.message.update.success')
  end
end
