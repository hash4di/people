require 'spec_helper'

describe 'Scheduling booked page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer) }
  let!(:project) { create(:project) }
  let!(:membership_for_developer) do
    create(
      :membership,
      starts_at: DateTime.current + 1.month,
      ends_at: nil,
      user: developer,
      booked: true,
      project: project
    )
  end
  let!(:scheduling_booked_page) { App.new.scheduling_booked_page }
  let(:user_row) { scheduling_booked_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_booked_page.load
  end

  it 'displays booked technical users' do
    expect(user_row.profile.name).to have_content developer.last_name
  end

  it 'displays a project in the booked column' do
    expect(user_row.booked_project).to have_link project.name
  end
end
