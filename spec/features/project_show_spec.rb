require 'spec_helper'

describe 'Project show view', js: true do
  let!(:admin_user) { create(:user, :admin, :developer) }
  let!(:project) { create(:project) }
  let!(:membership) { create(:membership, project: project) }

  let!(:project_show_page) { ProjectShowPage.new }

  before do
    log_in_as admin_user
    project_show_page.load(project_id: project.id)
  end

  describe 'rendering timeline on show page' do
    it_behaves_like 'has timeline visible'
    it_behaves_like 'has timeline event visible'
  end
end
