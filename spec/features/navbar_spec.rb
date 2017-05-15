require 'spec_helper'

describe 'Navbar', js: true do
  let(:home_page) { App.new.home_page }

  before do
    log_in_as user
    home_page.load
    home_page.menu.skills.click
  end

  context 'when user is a leader' do
    let(:leader) { create :user, :leader }
    let(:user) { leader }

    it 'sees his team members history' do
      team = leader.teams.first
      users = team.users
      users_without_leader = users - [leader]

      users_without_leader.each do |user|
        user_name = "#{user.last_name} #{user.first_name}"
        expect(home_page.menu.skills).to have_content(user_name)
      end
    end
  end

  context 'when user is normal user' do
    let(:user) { create(:user, :developer) }

    it 'does not see any team members' do
      expect(home_page.menu).to have_no_team_members
    end
  end

  context 'when user is an admin' do
    let(:user) { create(:user, :admin) }

    it 'has access to the admin section' do
      expect(home_page.menu).to have_admin_section
    end
  end
end
