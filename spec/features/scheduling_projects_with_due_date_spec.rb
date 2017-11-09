require 'spec_helper'

describe 'Scheduling in commercial projects with due date page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer) }
  let!(:project) { create(:project) }
  let!(:current_membership_for_developer) do
    create(
      :membership,
      starts_at: DateTime.current - 2.months,
      ends_at: DateTime.current,
      user: developer,
      project: project
    )
  end
  let!(:scheduling_projects_with_due_date_page) { App.new.scheduling_projects_with_due_date_page }
  let(:user_row) { scheduling_projects_with_due_date_page.user_rows.first }

  before do
    log_in_as admin_user
    scheduling_projects_with_due_date_page.load
  end

  it 'displays technical users in commercial projects with due date' do
    expect(user_row.profile.name).to have_content developer.last_name
  end
end
