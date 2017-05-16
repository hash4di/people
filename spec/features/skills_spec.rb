require 'spec_helper'

describe 'Skills page', js: true do
  let(:skills_page) { App.new.skills_page }
  let(:skills_new_page) { App.new.skills_new_page }
  let(:draft_skills_page) { App.new.draft_skills_page }
  let(:skill_edit_page) { App.new.skill_edit_page }
  let(:draft_skill_edit_page) { App.new.draft_skill_edit_page }

  let(:skill_category_1) { create :skill_category, name: 'backend' }
  let(:skill_category_2) { create :skill_category, name: 'ios' }

  let(:skills_range) { create_list :skill, 2, :with_range_rate_type, skill_category: skill_category_1 }
  let(:skills_boolean) { create_list :skill, 2, :with_boolean_rate_type, skill_category: skill_category_2 }

  let!(:admin_user) { create(:user, :admin, skills: skills_range + skills_boolean) }

  before { log_in_as admin_user }

  context 'when Admin is working on his skills' do
    before { skills_page.load }

    def skill_form(page)
      page.skill_name.set 'capybara'
      page.skill_description.set 'test test test'
      page.skill_rate_type.select 'range'
      page.skill_category.select 'backend'
      page.requester_explanation.set 'test test test'
      page.create_skill.click
    end

    scenario 'he can add new skill' do
      skills_page.add_new_skill.click
      skill_form(skills_new_page)
      expect(draft_skills_page).to have_content I18n.t('skills.message.create.success')
    end

    scenario 'he can NOT add new skill without mandatory fields' do
      skills_page.add_new_skill.click
      skills_new_page.create_skill.click
      expect(skills_page).to have_content 'Skill category and skill name have to be set.'
    end

    scenario 'he can edit skill' do
      skills_page.edit_skill.first.click
      skill_form(skill_edit_page)
      expect(draft_skills_page).to have_content I18n.t('skills.message.update.success')
    end
  end

  context 'when Admin is working on requested changes' do
    let(:success_message) { I18n.t('drafts.message.update.success') }

    context 'created by another user' do
      let!(:draft_skill) { create :draft_skill, :with_create_draft_type, skill_category: skill_category_1 }
      let(:success_message) { I18n.t('drafts.message.update.success') }

      before do
        draft_skills_page.load
        draft_skills_page.edit_skill.first.click
      end

      scenario 'he can accept draft skill' do
        draft_skill_edit_page.reviewer_explanation.set 'test reason'
        draft_skill_edit_page.accept_button.click
        expect(draft_skills_page).to have_content success_message
        visit '/skills'
        expect(skills_page).to have_content draft_skill.name
      end

      scenario 'he can reject draft skill' do
        draft_skill_edit_page.reviewer_explanation.set 'test reason'
        draft_skill_edit_page.cancel_button.click
        expect(draft_skills_page).to have_content success_message
        visit '/skills'
        expect(skills_page).to_not have_content draft_skill.name
      end

      scenario 'he can NOT accept skill without reviewer explanation' do
        draft_skill_edit_page.cancel_button.click
        expect(draft_skill_edit_page).to have_content 'can\'t be blank'
      end
    end

    context 'created by him' do
      let!(:draft_skill) do
        create :draft_skill,
          :with_create_draft_type,
          skill_category: skill_category_1,
          requester: admin_user
      end

      before { draft_skills_page.load }

      scenario 'he can NOT edit skill' do
        expect(draft_skills_page.edit_skill.first[:class]).to include 'disabled'
      end
    end

    context 'edited by another user' do
      let(:skill) { create :skill, skill_category_id: skill_category_1.id }
      let!(:draft_skill) do
        create :draft_skill,
          :with_update_draft_type,
          original_skill_details: original_skill_details,
          skill: skill
      end
      let(:original_skill_details) do
        {
          name: skill.name,
          description: skill.description,
          rate_type: skill.rate_type,
          skill_category_id: skill.skill_category_id
        }
      end

      scenario 'he can accept edited skill' do
        draft_skills_page.load
        draft_skills_page.edit_skill.first.click
        draft_skill_edit_page.reviewer_explanation.set 'test reason'
        draft_skill_edit_page.accept_button.click
        expect(draft_skills_page).to have_content success_message
      end
    end
  end
end
