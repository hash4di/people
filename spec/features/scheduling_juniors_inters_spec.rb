require 'spec_helper'

describe 'Scheduling juniors/inters page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:junior) { create(:user, :junior) }
  let!(:intern) { create(:user, :intern)}
  let!(:project) { create(:project, starts_at: DateTime.now, end_at: nil) }
  let!(:junior_membership) { create(:membership, user: junior, project: project) }
  let!(:intern_membership) { create(:membership, user: intern, project: project) }
  let!(:scheduling_juniors_inters_page) { App.new.scheduling_juniors_inters_page }
  let(:user_row) { scheduling_juniors_inters_page.user_rows}

  before do
    log_in_as admin_user
    scheduling_juniors_inters_page.load
  end

  it 'displays juniors and inters' do
    expect(user_row.first.profile.name).to have_content junior.last_name
    expect(user_row.second.profile.name).to have_content intern.last_name
  end
end
