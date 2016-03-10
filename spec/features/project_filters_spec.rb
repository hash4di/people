require 'spec_helper'

describe 'Project dashboard filters', js: true do
  let!(:admin_user) { create(:user, :admin, :developer) }
  let!(:dev_user) { create(:user, :admin, :developer, last_name: 'Developer', first_name: 'Daisy') }
  let!(:membership) { create(:membership, user: dev_user, project: project_test) }
  let!(:project_zztop) { create(:project, name: 'zztop') }
  let!(:project_test) { create(:project, name: 'test') }

  let(:projects_page) { App.new.projects_page }

  before(:each) do
    log_in_as admin_user
    projects_page.load
  end

  describe 'users filter' do
    it 'returns only matched projects when user name provided' do
      react_select('.filter.users', 'Developer Daisy')
      expect(projects_page).to have_text('test')
      expect(projects_page).to_not have_text('zztop')
    end

    it 'returns all projects when no selectize provided' do
      expect(projects_page).to have_text('zztop')
      expect(projects_page).to have_text('test')
    end

    context 'when user has not started a project' do
      let!(:junior_role) { create(:role, name: 'junior') }
      let!(:future_dev) { create(:user, primary_role: junior_role) }
      let!(:future_membership) do
        create(:membership, :future, user: future_dev, project: project_zztop)
      end

      it 'does not show the project' do
        projects_page.project_types.active_tab.click
        expect(projects_page).to have_text('zztop')
        react_select('.filter.users', future_dev.decorate.name)
        expect(page).to_not have_text('zztop')
      end
    end
  end

  describe 'projects filter' do
    it 'shows all projects when empty string provided' do
      within '#projects-users' do
        expect(projects_page).to have_text('zztop')
        expect(projects_page).to have_text('test')
      end
    end

    it 'shows only matched projects when project name provided' do
      react_select('.filter.projects', 'zztop')

      within '#projects-users' do
        expect(projects_page).to have_text('zztop')
        expect(projects_page).not_to have_text('test')
      end
    end
  end
end
