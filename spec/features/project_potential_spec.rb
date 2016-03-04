require 'spec_helper'

describe 'Potential project', js: true do
  let!(:project) { create :project, :potential }
  let!(:admin_user) { create :user, :admin }
  let!(:user) { create :user }

  before do
    log_in_as(admin_user)
  end

  context "when 'stays' is unchecked" do
    let!(:membership) { create :membership, project: project, user: user }

    before do
      visit edit_project_path(project)
    end

    it 'shows potential memberships' do
      expect(page).to have_content("#{user.decorate.name}")
    end

    it 'deletes membership when project is updated to nonpotential' do
      uncheck(membership.user.decorate.name)
      uncheck('Potential')
      click_button('Save')
      visit user_path(user)
      within('.user-projects') { expect(page).not_to have_content(project.name) }
      within('.time-section') { expect(page).not_to have_content(project.name) }
    end
  end

  context "when 'stays' is checked" do
    let!(:membership) { create :membership, project: project, user: user }

    before do
      visit edit_project_path(project)
    end

    it 'shows potential memberships' do
      expect(page).to have_content("#{user.decorate.name}")
    end

    it "doesn't delete membership when project is updated to nonpotential" do
      uncheck('Potential')
      click_button('Save')
      visit user_path(user)
      within('.user-projects') { expect(page).to have_content(project.name) }
    end
  end
end
