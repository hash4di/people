require 'spec_helper'

describe 'Scheduling unavailable page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer) }
  let!(:project) { create(:project, name: 'unavailable') }
  let!(:membership_for_developer) do
    create(
      :membership,
      starts_at: DateTime.current - 2.days,
      ends_at: DateTime.current + 1.month,
      user: developer,
      project: project
    )
  end
  let!(:scheduling_unavailable_page) { App.new.scheduling_unavailable_page }
  let(:user_row) { scheduling_unavailable_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_unavailable_page.load
  end

  it 'displays unavailable technical users' do
    expect(user_row.profile.name).to have_content developer.last_name
  end
end
