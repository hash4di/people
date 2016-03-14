require 'spec_helper'

describe 'Team view', js: true do
  let(:admin_user) { create(:user, :admin, email: AppConfig.emails.admin[0]) }
  let(:hidden_role) { create(:role, show_in_team: false) }
  let(:team) { create(:team) }

  let(:added_user_first_name) { 'Developer' }
  let(:added_user_last_name) { 'Daisy' }
  let!(:dev_user) { create(:user, :admin, :developer, first_name: added_user_first_name,
      last_name: added_user_last_name) }
  let!(:non_dev_user) { create(:user, :intern, first_name: 'Nondev Nigel') }
  let!(:archived_user) { create(:user, first_name: 'Archived Arthur', archived: true) }
  let!(:no_role_user) { create(:user, first_name: 'Norole Nicola') }
  let!(:hidden_user) { create(:user, first_name: 'Hidden Amanda', primary_role: hidden_role,
    teams: [team]) }
  let!(:hidden_user_position) { create(:position, :primary, user: hidden_user, role: hidden_role) }
  let!(:team_user) { create(:user, :developer, first_name: 'Developer Dave', teams: [team]) }
  let!(:junior_team_user) { create(:user, :junior, first_name: 'Junior Jake', teams: [team]) }

  let!(:teams_page) { App.new.teams_page }

  before do
    log_in_as admin_user
    teams_page.load
  end

  describe '.show-users button' do
    before { find('.show-users').click }

    it "doesn't show archived users" do
      expect(page).not_to have_content archived_user.first_name
    end

    it 'shows only users with roles chosen by admin' do
      expect(page).not_to have_content hidden_user.first_name
    end
  end

  describe '.new-team-add' do
    before { find('.new-team-add').click }

    it 'shows new team form' do
      expect(page).to have_css('.js-new-team-form')
      expect(page).to have_content 'Add team'
    end

    it 'adds new team' do
      expect(Team.count).to eq 1
      find('.js-new-team-form .form-control.name').set('teamX')
      find('a.new-team-submit').click
      expect(page).to have_content 'teamX has been created'
      expect(Team.count).to eq 2
    end
  end

  describe '.js-promote-leader' do
    let(:promoted_user) { [team_user, junior_team_user].sort_by(&:last_name).first.decorate }
    let(:success_msg) { 'New leader promoted!' }

    it 'promotes member to leader' do
      find('.js-promote-leader', match: :first, visible: false).hover
      find('.js-promote-leader', match: :first).click
      expect(page).not_to have_css('ul.team-members.empty')
      expect(page).to have_css('ul.team-members.filled')
      expect(page).to have_content(success_msg)
      # select another user as a leader
      find('.js-promote-leader', match: :first).click
      expect(page).to have_css('ul.team-members.filled')
      expect(page).to have_content(success_msg)
    end
  end

  describe '.js-edit-team' do
    before { find('.js-edit-team').click }

    let(:new_team_name) { 'Relatively OK team' }
    let(:success_msg) { "Team #{new_team_name} changed successfully" }
    let(:error_msg) { 'New name not provided' }

    it 'shows edit form' do
      expect(page).to have_css('.modal-dialog.edit-team')
    end

    # TODO: find out why failing on circle
    xit 'updates team name' do
      find('input.new-name').set(new_team_name)
      find('button.save').click
      expect(page).to have_content(new_team_name)
      expect(page).to have_content(success_msg)
    end

    xit 'fails to update team name' do
      find('button.save').click
      expect(page).to have_content(error_msg)
    end

    it 'closes edit form' do
      find('button.cancel').click
      expect(page).to_not have_css('.modal-dialog.edit-team')
    end
  end

  describe '.add-user-to-team' do
    context 'when current_user is not an admin' do
      it 'is not visible' do
        log_in_as dev_user
        expect(page).not_to have_css('footer.add-user-to-team')
      end
    end

    context 'when current_user is an admin' do
      it 'is visible' do
        expect(page).to have_css('footer.add-user-to-team')
      end

      it 'adds a new member to the team' do
        expect(page).to have_css('.membership', count: 2)
        react_select('footer.add-user-to-team', dev_user.decorate.name)
        expect(page).to have_css('.membership', count: 3)
        expect(page).to have_content("User #{dev_user.decorate.name} added to team")
      end
    end
  end

  describe '.member-details' do
    it 'displays archived label for archived users' do
      team_user.update_attribute(:archived, true)
      visit current_path
      expect(page).to have_content('archived')
    end
  end

  describe '.devs-indicator' do
    it 'shows number of users in team' do
      indicator = first('.devs-indicator')
      devs_indicator = indicator.first('.devs').text
      jnrs_indicator = indicator.first('.jnrs').text
      expect(devs_indicator).to eq '1'
      expect(jnrs_indicator).to eq '1'
    end
  end
end
