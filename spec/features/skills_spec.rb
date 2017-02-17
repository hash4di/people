require 'spec_helper'

describe 'Skills page', js: true do
  let(:skills_page) { App.new.skills_page }
  let(:skills_new_page) { App.new.skills_new_page }
  let(:draft_skills_page) { App.new.draft_skills_page }

  let(:skill_category_1) { create :skill_category, name: 'backend' }
  let(:skill_category_2) { create :skill_category, name: 'ios' }

  let(:skills_range) { create_list :skill, 2, :with_range_rate_type, skill_category: skill_category_1 }
  let(:skills_boolean) { create_list :skill, 2, :with_boolean_rate_type, skill_category: skill_category_2 }

  let!(:admin_user) { create(:user, :admin, skills: skills_range + skills_boolean) }

  before do
    log_in_as admin_user
    skills_page.load
  end

  it 'adds new skill' do
    skills_page.add_new_skill.click
    skills_new_page.skill_name.set 'capybara'
    skills_new_page.skill_description.set 'test test test'
    skills_new_page.skill_rate_type.select 'range'
    skills_new_page.skill_category.select 'backend'
    skills_new_page.requester_explanation.set 'test test test'
    skills_new_page.create_skill.click
    expect(draft_skills_page).to have_content I18n.t('skills.message.create.success')
  end
end
