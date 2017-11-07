require 'spec_helper'

describe 'Scheduling not scheduled page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer) }
  let!(:scheduling_not_scheduled_page) { App.new.scheduling_not_scheduled_page }
  let(:user_row) { scheduling_not_scheduled_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_not_scheduled_page.load
  end

  it 'displays not scheduled technical users' do
    expect(user_row.profile.name).to have_content developer.last_name
  end

  it 'displays a placeholder instead of a project' do
    expect(user_row.current_project).to have_content 'No current projects.'
  end
end
