require 'spec_helper'

describe 'Scheduling juniors/inters page', js: true do
  let(:admin_user) { create(:user, :admin) }
  let!(:junior) { create(:user, :junior) }
  let!(:intern) { create(:user, :intern)}
  let!(:project) { create(:project, starts_at: DateTime.now, end_at: nil) }
  let!(:junior_membership) { create(:membership, user: junior, project: project) }
  let!(:intern_membership) { create(:membership, user: intern, project: project) }
  let!(:scheduling_juniors_inters_page) { App.new.scheduling_juniors_inters_page }

  before do
    log_in_as admin_user
    scheduling_juniors_inters_page.load
  end

  it 'displays juniors and inters' do
    expect(page).to have_content junior.last_name
    expect(page).to have_content intern.last_name
  end
end
