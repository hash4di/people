require 'spec_helper'

describe 'Scheduling booked page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer)}
  let!(:project) { create(:project) }
  let!(:membership_for_developer) do
    create :membership,
            starts_at: DateTime.current + 2.months,
            ends_at: nil,
            user: developer,
            booked: true,
            project: project
  end
  let!(:scheduling_booked_page) { App.new.scheduling_booked_page }

  before do
    log_in_as admin_user
    scheduling_booked_page.load
  end

  it 'displays booked technical users' do
    expect(page).to have_content developer.last_name
    expect(scheduling_booked_page.user_rows.first.booking_projects).to have_link project.name
  end
end
