require 'spec_helper'

describe 'Scheduling in rotations page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:developer) { create(:user, :developer)}
  let!(:project_1) { create(:project) }
  let!(:project_2) { create(:project) }
  let!(:current_membership_for_developer) do
    create :membership,
            starts_at: DateTime.current - 2.months,
            ends_at: DateTime.current,
            user: developer,
            project: project_1
  end
  let!(:next_membership_for_developer) do
    create :membership,
            starts_at: DateTime.current + 2.days,
            ends_at: nil,
            user: developer,
            project: project_2
  end
  let!(:scheduling_in_rotations_page) { App.new.scheduling_in_rotations_page }

  before do
    log_in_as admin_user
    scheduling_in_rotations_page.load
  end

  it 'displays technical users in rotation in progress' do
    expect(page).to have_content developer.last_name
  end
end
