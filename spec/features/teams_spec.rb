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
    wait_for_ajax
  end

  describe "'show users without team' button" do
    before { teams_page.show_users_button.click }

    it "doesn't show archived users" do
      expect(page).not_to have_content archived_user.first_name
    end

    it 'shows only users with roles chosen by admin' do
      expect(page).not_to have_content hidden_user.first_name
    end
  end

  describe "'new team' button" do
    before { teams_page.new_team_button.click }

    it 'shows new team form' do
      expect(teams_page).to have_new_team_form
      expect(page).to have_content 'Add team'
    end

    it 'adds new team' do
      expect(Team.count).to eq 1
      teams_page.new_team_name_input.set('teamX')
      teams_page.save_team_button.click
      expect(page).to have_content 'teamX has been created'
      expect(Team.count).to eq 2
    end
  end

  describe "'promote to leader' button" do
    let(:promoted_user) { [team_user, junior_team_user].sort_by(&:last_name).first.decorate }
    let(:success_msg) { 'New leader promoted!' }

    it 'promotes member to leader' do
      page.execute_script "$('.membership').trigger('mouseover')"
      teams_page.promote_to_leader_icons.first.click
      wait_for_ajax
      expect(teams_page).not_to have_empty_leader_rows
      expect(teams_page).to have_filled_leader_rows
    end
  end

  describe "'add user to team' dropdown" do
    context 'when current_user is not an admin' do
      it 'is not visible' do
        log_in_as dev_user
        expect(teams_page).to have_no_add_user_dropdowns
      end
    end

    context 'when current_user is an admin' do
      it 'is visible' do
        expect(teams_page).to have_add_user_dropdowns
      end

      it 'adds a new member to the team' do
        expect(teams_page.memberships.count).to eq 2
        react_select('footer.add-user-to-team', dev_user.decorate.name)
        wait_for_ajax
        expect(teams_page.memberships.count).to eq 3
        expect(page).to have_content("User #{dev_user.decorate.name} added to team")
      end
    end
  end

  describe '.member-details' do
    it 'displays archived label for archived users' do
      team_user.update_attribute(:archived, true)
      teams_page.load
      expect(page).to have_content('unavailable')
    end
  end

  describe '.devs-indicator' do
    it 'shows number of users in team' do
      expect(teams_page.billable_indicators.first.text).to eq '1'
      expect(teams_page.non_billable_indicators.first.text).to eq '1'
    end
  end
end
