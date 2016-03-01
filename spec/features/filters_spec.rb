require 'spec_helper'

describe 'Dashboard filters', js: true do
  let(:admin_user) { create(:user, :admin) }
  let(:dev_role) { create(:role, name: 'developer') }
  let(:role) { create(:role_billable) }
  let!(:dev_position) { create(:position, :primary, user: dev_user, role: dev_role) }
  let!(:admin_dev_position) { create(:position, :primary, user: admin_user, role: dev_role) }

  let!(:dev_user) do
    create(:user, :admin, last_name: 'Developer', primary_role: dev_role,
      first_name: 'Daisy')
  end

  let!(:membership) do
    create(:membership, user: dev_user, project: project_test, role: role)
  end

  let!(:project_zztop) { create(:project, name: 'zztop') }
  let!(:project_test) { create(:project, name: 'test') }

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')

    visit '/dashboard'
  end

  describe 'users filter' do
    it 'returns only matched projects when user name provided' do
      find('.filter.users .Select-control').click
      find( 'div.Select-option', text: 'Developer Daisy' ).click
      expect(page).to have_text('test')
      expect(page).to_not have_text('zztop')
    end

    it 'returns all projects when no selectize provided' do
      expect(page).to have_text('zztop')
      expect(page).to have_text('test')
    end

    context 'when user has not started a project' do
      let!(:junior_role) { create(:role, name: 'junior') }
      let!(:future_dev) { create(:user, primary_role: junior_role) }
      let!(:future_membership) { create(:membership, user: future_dev, starts_at: 1.week.from_now,
        project: project_zztop) }

      it 'does not show the project' do

        full_name = "#{future_dev.last_name} #{future_dev.first_name}"
        visit '/dashboard'

        expect(page).to have_text('zztop')
        find('.filter.users .Select-control').click
        find( 'div.Select-option', text: full_name ).click

        expect(page).to_not have_text('zztop')
      end
    end
  end

  describe 'projects filter' do
    it 'shows all projects when empty string provided' do
      within '#projects-users' do
        expect(page).to have_text('zztop')
        expect(page).to have_text('test')
      end
    end

    it 'shows only matched projects when project name provided' do
      find('.filter.projects .Select-control').click
      find( 'div.Select-option', text: 'zztop' ).click

      within '#projects-users' do
        expect(page).to have_text('zztop')
        expect(page).not_to have_text('test')
      end
    end
  end
end
