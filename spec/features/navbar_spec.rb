require 'spec_helper'

describe 'Navbar', js: true do

  context 'when user is a leader' do
    let!(:leader) { create(:user, :leader) }
    let!(:home_page) { App.new.home_page }

    before do
      log_in_as leader
      home_page.load
    end

    it 'sees his team members history' do
      home_page.menu.skills.click

      team = leader.teams.first
      users = team.users
      users_without_leader = users - [leader]

      users_without_leader.each do |user|
        user_name = "#{user.last_name} #{user.first_name}"
        expect(home_page.menu.skills).to have_content(user_name)
      end
    end
  end
end
