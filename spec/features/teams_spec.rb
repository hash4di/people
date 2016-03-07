require 'spec_helper'

describe 'team view', js: true do
  let(:admin_user) { create(:user, :admin, email: AppConfig.emails.admin[0]) }
  let(:billable_role) { create(:role_billable, name: 'ror') }
  let(:non_dev_role) { create(:role, name: 'junior qa') }
  let(:hidden_role) { create(:role, show_in_team: false) }
  let(:team) { create(:team) }
  let!(:dev_role) { create(:role, name: 'developer') }
  let!(:junior_role) { create(:role, name: 'junior', billable: false) }

  let(:added_user_first_name) { 'Developer' }
  let(:added_user_last_name) { 'Daisy' }
  let!(:dev_user) do
    create(
      :user,
      :admin,
      first_name: added_user_first_name,
      last_name: added_user_last_name,
      primary_role: billable_role
    )
  end
  let!(:dev_position) { create(:position, :primary, user: dev_user, role: billable_role) }

  let!(:non_dev_user) do
    create(:user, first_name: 'Nondev Nigel', primary_role: non_dev_role)
  end
  let!(:non_dev_position) { create(:position, :primary, user: non_dev_user, role: non_dev_role) }

  let!(:archived_user) do
    create(:user, first_name: 'Archived Arthur', archived: true)
  end

  let!(:no_role_user) { create(:user, first_name: 'Norole Nicola') }

  let!(:hidden_user) do
    create(
      :user,
      first_name: 'Hidden Amanda', primary_role: hidden_role, teams: [team]
    )
  end
  let!(:hidden_user_position) { create(:position, :primary, user: hidden_user, role: hidden_role) }

  let!(:team_user) do
    create(
      :user,
      first_name: 'Developer Dave', primary_role: billable_role, teams: [team]
    )
  end
  let!(:team_user_position) { create(:position, :primary, user: team_user, role: billable_role) }

  let!(:junior_team_user) do
    create(
      :user,
      first_name: 'Junior Jake', primary_role: junior_role, teams: [team]
    )
  end
  let!(:junior_user_position) do
    create(:position, :primary, user: junior_team_user, role: junior_role)
  end

  before(:each) do
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(admin_user).unshift('User')

    visit '/teams'
  end

  describe '.show-users button' do
    before(:each) do
      find('.show-users').click
    end

    it "doesn't show archived users" do
      expect(page).not_to have_content archived_user.first_name
    end

    it 'shows only users with roles chosen by admin' do
      expect(page).not_to have_content hidden_user.first_name
    end
  end

  describe '.new-team-add' do
    before(:each) do
      find('.new-team-add').click
    end

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
    let(:success_msg) do
      'New leader promoted!'
    end

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
    before(:each) do
      find('.js-edit-team').click
    end

    let(:new_team_name) { 'Relatively OK team' }

    let(:success_msg) do
      "Team #{new_team_name} changed successfully"
    end

    let(:error_msg) do
      'New name not provided'
    end

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
        page.set_rack_session 'warden.user.user.key' => User
          .serialize_into_session(dev_user).unshift('User')
        expect(page).not_to have_css('footer.add-user-to-team')
      end
    end

    context 'when current_user is an admin' do
      let(:added_user_name) { "#{added_user_last_name} #{added_user_first_name}" }

      it 'is visible' do
        expect(page).to have_css('footer.add-user-to-team')
      end

      it 'adds a new member to the team' do
        expect(page).to have_css('.membership', count: 2)
        react_select('footer.add-user-to-team', added_user_name)
        expect(page).to have_css('.membership', count: 3)
        expect(page).to have_content("User #{added_user_name} added to team")
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
