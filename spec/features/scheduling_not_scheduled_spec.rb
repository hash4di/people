require 'spec_helper'

describe 'Scheduling not scheduled page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer)}
  let!(:scheduling_not_scheduled_page) { App.new.scheduling_not_scheduled_page }

  before do
    log_in_as admin_user
    scheduling_not_scheduled_page.load
  end

  it 'displays not scheduled technical users' do
    expect(page).to have_content developer.last_name
    expect(scheduling_not_scheduled_page.user_rows.first.current_projects)
      .to have_content 'No current projects.'
  end
end
