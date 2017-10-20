require 'spec_helper'

describe 'Scheduling to rotate page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer)}
  let!(:project) { create(:project, starts_at: DateTime.now, end_at: nil) }
  let!(:current_membership_for_developer) do
    create :membership,
            starts_at: DateTime.current - 9.months,
            ends_at: nil,
            user: developer,
            project: project
  end
  let!(:scheduling_to_rotate_page) { App.new.scheduling_to_rotate_page }
  let(:user_row) { scheduling_to_rotate_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_to_rotate_page.load
  end

  it 'displays technical users to rotate' do
    expect(user_row.profile.name).to have_content developer.last_name
  end
end
