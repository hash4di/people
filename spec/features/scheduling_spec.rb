require 'spec_helper'

describe 'Scheduling page', js: true do
  let(:admin_user) { create(:user, :admin, :developer) }
  let!(:dev_without_skills) { create(:user, :developer) }
  let(:dev_with_two_skills) { create(:user, :developer) }
  let(:ember_dev) { create(:user, :developer) }
  let(:angular_skill) { create(:skill, name: 'AngularJS') }
  let!(:user_skill_rate1) do
    create(:user_skill_rate, user: dev_with_two_skills, skill: angular_skill, rate: 1)
  end
  let(:ember_skill) { create(:skill, name: 'EmberJS') }
  let!(:user_skill_rate2) do
    create(:user_skill_rate, user: dev_with_two_skills, skill: ember_skill, rate: 1)
  end
  let!(:user_skill_rate3) do
    create(:user_skill_rate, user: ember_dev, skill: ember_skill, rate: 1)
  end
  let!(:another_dev) { create(:user, :developer) }
  let!(:developer) { create(:developer_in_project, :with_project_scheduled_with_due_date) }
  let!(:pm) { create(:pm_user) }
  let!(:next_project) { create(:project, starts_at: DateTime.now, end_at: nil) }
  let!(:next_membership_for_developer) do
    create(:membership, {
             starts_at: DateTime.current + 2.months,
             ends_at: nil,
             user: developer,
             project: next_project
           })
  end
  let!(:scheduling_page) { App.new.scheduling_page }

  before do
    log_in_as admin_user
    scheduling_page.load
  end

  describe 'filters' do
    it 'allows to filter by skills' do
      expect(page).to have_content dev_with_two_skills.last_name
      expect(page).to have_content dev_without_skills.last_name
      expect(page).to have_content ember_dev.last_name
      wait_for_ajax
      react_select('.skills', 'EmberJS')
      expect(page).to have_content dev_with_two_skills.last_name
      expect(page).to_not have_content dev_without_skills.last_name
      expect(page).to have_content ember_dev.last_name
      react_select('.skills', 'AngularJS')
      expect(page).to have_content dev_with_two_skills.last_name
      expect(page).to_not have_content ember_dev.last_name
      expect(page).to_not have_content dev_without_skills.last_name
    end
  end

  describe 'table with users' do
    it 'displays users' do
      expect(page).to have_content another_dev.last_name
    end

    it 'displays only technical users' do
      expect(page).not_to have_content pm.last_name
    end
  end

  describe 'next project same as current' do
    it 'displays project twice for a specific user' do
      expect(page.all('a', text: next_membership_for_developer.project.name).size).to eql(1)
      expect(page.all('a', text: next_project.name).size).to eql(1)
    end
  end
end
