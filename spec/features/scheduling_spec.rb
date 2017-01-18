require 'spec_helper'

describe 'Scheduling page', js: true do
  let(:admin_user) { create(:user, :admin, :developer) }
  let!(:angular_ability) { create(:ability, name: 'AngularJS') }
  let!(:dev_with_no_skillz) { create(:user, :developer) }
  let!(:angular_dev) { create(:user, :developer, abilities: [angular_ability]) }
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
    it 'allows to filter by abilities' do
      expect(page).to have_content angular_dev.last_name
      expect(page).to have_content dev_with_no_skillz.last_name
      wait_for_ajax
      react_select('.abilities', 'AngularJS')
      expect(page).to have_content angular_dev.last_name
      expect(page).to_not have_content dev_with_no_skillz.last_name
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
