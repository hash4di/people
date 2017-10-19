require 'spec_helper'

describe 'Scheduling in internals page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer)}
  let!(:project) { create(:project, :internal, starts_at: DateTime.now) }
  let!(:dev_membership) { create(:membership, user: developer, project: project) }
  let!(:scheduling_in_internals_page) { App.new.scheduling_in_internals_page }
  let(:user_row) { scheduling_in_internals_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_in_internals_page.load
  end

  it 'displays technical users in internals' do
    expect(user_row.profile.name).to have_content developer.last_name
  end

  it 'displays an internal label in the project column' do
    expect(user_row.current_project).to have_internal_label
  end
end
