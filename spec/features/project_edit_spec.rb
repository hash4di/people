require 'spec_helper'

describe 'Project editing', js: true do
  let!(:admin_user) { create :user, :admin }
  let!(:user) { create :user, :developer }
  let(:project) { create(:project) }
  let!(:potential_project) { create :project, :potential }
  let!(:membership) { create :membership, project: potential_project, user: user }

  let!(:project_edit_page) { App.new.project_edit_page }

  before do
    log_in_as admin_user
    project_edit_page.load(project_id: project.id)
  end

  describe 'regular projects' do
    it 'allows to edit project' do
      fill_in('project_name', with: 'Edited project')
      fill_in('project_kickoff', with: Date.today)
      fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
      project_edit_page.save_button.click
      expect(project_edit_page).to have_content('Edited project')
    end
  end

  describe 'potential projects' do
    before { project_edit_page.load(project_id: potential_project.id) }

    context "when 'stays' is unchecked" do
      it 'shows potential memberships' do
        expect(page).to have_content(user.decorate.name)
      end

      it 'deletes membership when project is updated to nonpotential' do
        uncheck(membership.user.decorate.name)
        uncheck('Potential')
        click_button('Save')
        visit user_path(user)
        within('.user-projects') { expect(page).not_to have_content(potential_project.name) }
        within('.time-section') { expect(page).not_to have_content(potential_project.name) }
      end
    end

    context "when 'stays' is checked" do
      it 'shows potential memberships' do
        expect(page).to have_content(user.decorate.name)
      end

      it "doesn't delete membership when project is updated to nonpotential" do
        uncheck('Potential')
        project_edit_page.save_button.click
        visit user_path(user)
        expect(page).to have_content(potential_project.name)
      end
    end
  end
end
